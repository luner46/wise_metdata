package kr.co.wisesys.modShpParser;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringWriter;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.log4j.Logger;
import org.geotools.api.data.DataStore;
import org.geotools.api.data.DataStoreFinder;
import org.geotools.api.data.SimpleFeatureSource;
import org.geotools.api.feature.Property;
import org.geotools.api.feature.simple.SimpleFeature;
import org.geotools.api.feature.simple.SimpleFeatureType;
import org.geotools.api.feature.type.AttributeDescriptor;
import org.geotools.api.referencing.FactoryException;
import org.geotools.api.referencing.crs.CoordinateReferenceSystem;
import org.geotools.api.referencing.operation.MathTransform;
import org.geotools.api.referencing.operation.TransformException;
import org.geotools.data.shapefile.ShapefileDataStore;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.feature.DefaultFeatureCollection;
import org.geotools.feature.FeatureCollection;
import org.geotools.feature.FeatureIterator;
import org.geotools.feature.simple.SimpleFeatureBuilder;
import org.geotools.feature.simple.SimpleFeatureTypeBuilder;
import org.geotools.geojson.feature.FeatureJSON;
import org.geotools.geometry.jts.JTS;
import org.geotools.referencing.CRS;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.MultiPolygon;
import org.locationtech.jts.geom.Polygon;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

/**
 * <pre>
 * @ClassName   : ModShpParserService.java
 * @Description : SHP 파일 변환 모듈 Service
 * -----------------------------------------------------
 * 2025.08.06, 최준규, 최초 생성
 *
 * </pre>
 * @author 최준규
 * @since 2025.08.06
 * @version 1.0
 * @see reference
 *
 * @Copyright (c) 2025 by wiseplus All right reserved.
 */

@Configuration
@Service
public class ModShpParserService {
	
	@Autowired
	private ModShpParserDao dao;

	private final Logger log = Logger.getLogger(getClass());

    /**
	 * SHP 파일 > GeoJSON 변환 SERVICE
	 * 
	 * @author 최준규
	 * @since 2025.08.06
	 * @param MultipartFile inputFile
	 */
	
    public String convertToGeoJson(MultipartFile inputFile) throws IOException, FactoryException, TransformException {
    	File tempDir = null;
        DataStore dataStore = null;
        StringWriter stringWriter = new StringWriter();
        FeatureJSON featureJson = new FeatureJSON();
        
        try {
        	// 입력받은 shpFile을 컨트롤하기 위해 임시 폴더 생성 후, 해당 폴더에 복사
        	File uploadedFile = createTempDir(inputFile);
            tempDir = uploadedFile.getParentFile();

            // shp 파일의 구성요소(필수: .shp, .shx, .dbf, 선택: prj, qix, cpg)가 포함되어있는 zip 파일을 로드하여 압축 해제
        	if (inputFile.getOriginalFilename().endsWith(".zip")) {
                unzip(uploadedFile, tempDir);
            }
        	
        	// 압축 해제된 파일 중 shp 파일을 찾아 shpFile 변수에 저장
        	// 만약 해당 목록 중 shp 파일이 없을 경우, 예외 처리
        	File[] files = tempDir.listFiles((dir, name) -> name.endsWith(".shp"));
            File shpFile = files[0];
            
            // GeoTools에서는 dataStore를 사용해 shp 파일을 해석 및 편집
            // URL을 통해 dataStore에 shp 파일을 전달
            Map<String, Object> map = new HashMap<>();
            map.put("url", shpFile.toURI().toURL());
            dataStore = DataStoreFinder.getDataStore(map);
            
            // shp 파일에서 첫번째 Feature를 가져와 FeatureCollection에 저장 
            String orgnlTypeName = dataStore.getTypeNames()[0];
            SimpleFeatureSource orgnlFeatureSource = dataStore.getFeatureSource(orgnlTypeName);
            SimpleFeatureCollection orgnlFeatureCollection = orgnlFeatureSource.getFeatures();

            // 좌표계 정의
            // GeoJSON의 기본 좌표계는 EPSG:4326
            // OpenLayers에서 사용하는 좌표계는 EPSG:3857
            CoordinateReferenceSystem orgnlCRS = orgnlFeatureSource.getSchema().getCoordinateReferenceSystem();
            
            // EPSG:3857 좌표계를 변환
            // true를 통해 위경도 순서([lat,lon] or [lon,lat])를 CRS에 맞춰 자동 변경
            CoordinateReferenceSystem targetCRS = CRS.decode("EPSG:3857", true);
            
            // 원본 좌표계를 목표 좌표계로 변환
            // true를 통해 정확하지 일치하지 않는 위치더라도 최대한 비슷한 위치로 강제 변환
            MathTransform transform = CRS.findMathTransform(orgnlCRS, targetCRS, true);

            // 설정한 조건(좌표계 EPSG:3857)을 사용한 Feature 타입을 새롭게 정의
            SimpleFeatureTypeBuilder simpleFeatureTypeBuilder = new SimpleFeatureTypeBuilder();
            
            // 원본 Feature 타입의 이름을 그대로 사용
            simpleFeatureTypeBuilder.setName(orgnlFeatureSource.getSchema().getName());
            
            // 새로운 좌표계(EPSG:3857)을 적용
            simpleFeatureTypeBuilder.setCRS(targetCRS);
            
            // 기존에 존재하던 Feature 타입의 내용(attribute)을 그대로 사용
            for (AttributeDescriptor AttributeDescriptor : orgnlFeatureSource.getSchema().getAttributeDescriptors()) {
            	simpleFeatureTypeBuilder.add(AttributeDescriptor);
            }
            
            // 새로운 Feature 타입을 targetFeatureType 변수 안에 저장 (아래와 같은 Feature가 입력되어야 함)
            // Name, (new)CRS, attribute 
            SimpleFeatureType targetFeatureType = simpleFeatureTypeBuilder.buildFeatureType();
            
            // 개별 Feature를 targetFeatureType에 맞춰 생성하기 위한 Builder 정의
            SimpleFeatureBuilder featureBuilder = new SimpleFeatureBuilder(targetFeatureType);

            // GeoJSON으로 변환된 Feature를 저장할 Collection 생성
            DefaultFeatureCollection convertFeaturecollection = new DefaultFeatureCollection(null, targetFeatureType);

            // Collection에 저장하기 위해 FeatureInterator를 사용해 개별 Feature의 정보를 조회
            try (FeatureIterator<SimpleFeature> features = orgnlFeatureCollection.features()) {
               
            	// 다음 Feature가 있을 경우(마지막 Feature까지), 차례로 조회
            	while (features.hasNext()) {
                    SimpleFeature feature = features.next();

                    // 개별 Feature의 속성을 저장할 Object 배열 생성 
                    Object[] values = new Object[feature.getAttributeCount()];
                    
                    // 개별 Feature에서의 각 속성을 조회
                    for (int i = 0; i < feature.getAttributeCount(); i++) {
                    	
                    	// 현재 Feature의 속성을 정의
                        Object featureAttribute = feature.getAttribute(i);
                        
                        // 속성이 Geometry 타입(좌표계)일 경우, 좌표계 변환이 이루어짐
                        if (featureAttribute instanceof Geometry) {
                        	
                        	// 좌표계 변환
                            values[i] = JTS.transform((Geometry) featureAttribute, transform);
                            
                        // 아닐 경우, 기존 속성을 그대로 저장
                        } else {
                            values[i] = featureAttribute;
                        }
                    }
                    
                    // 새로운 Feature 타입을 저장 (좌표계 변환이 이루어짐)
                    SimpleFeature newFeature = featureBuilder.buildFeature(feature.getID(), values);
                    
                    // 생성된 Feature를 Collection에 추가
                    convertFeaturecollection.add(newFeature);
                }
            }

            // Feature -> FeatureCollection -> 좌표 변환 -> newFeatureCollection
            // Collection에 저장된 shp의 Feature 속성을 
            // featureJson을 사용하여 GeoJSON으로 변환한 뒤, StringWriter에 저장
            featureJson.writeFeatureCollection(convertFeaturecollection, stringWriter);
        } catch (FileNotFoundException e) {
            log.error(e.toString());
        } catch (IOException e) {
        	log.error(e.toString());
        } finally {
            // 변환 과정에서 GeoTools가 사용한 dataStore 자원을 해제
            if (dataStore != null) {dataStore.dispose();}

            // 임시 디렉토리가 남아있다면 해당 폴더 삭제
            if (tempDir != null && tempDir.exists()) {deleteTempDir(tempDir);}
        }
        
        // StringWriter에 저장되어있는 GeoJSON을 문자열로 변환하여 리턴
        return stringWriter.toString();
    }
    
    public String convertToKml(MultipartFile inputFile) throws IOException, FactoryException, TransformException, ParserConfigurationException, TransformerException {
    	File tempDir = null;
        DataStore dataStore = null;
        StringWriter stringWriter = new StringWriter();
        
        try {
        	// 입력받은 shpFile을 컨트롤하기 위해 임시 폴더 생성 후, 해당 폴더에 복사
        	File uploadedFile = createTempDir(inputFile);
            tempDir = uploadedFile.getParentFile();

            // shp 파일의 구성요소(필수: .shp, .shx, .dbf, 선택: prj, qix, cpg)가 포함되어있는 zip 파일을 로드하여 압축 해제
        	if (inputFile.getOriginalFilename().endsWith(".zip")) {
                unzip(uploadedFile, tempDir);
            }
        	
        	// 압축 해제된 파일 중 shp 파일을 찾아 shpFile 변수에 저장
        	// 만약 해당 목록 중 shp 파일이 없을 경우, 예외 처리
        	File[] files = tempDir.listFiles((dir, name) -> name.endsWith(".shp"));
            File shpFile = files[0];
            
            // GeoTools에서는 dataStore를 사용해 shp 파일을 해석 및 편집
            // URL을 통해 dataStore에 shp 파일을 전달
            Map<String, Object> map = new HashMap<>();
            map.put("url", shpFile.toURI().toURL());
            dataStore = DataStoreFinder.getDataStore(map);
            
            // shp 파일에서 첫번째 Feature를 가져와 FeatureCollection에 저장 
            String orgnlTypeName = dataStore.getTypeNames()[0];
            SimpleFeatureSource orgnlFeatureSource = dataStore.getFeatureSource(orgnlTypeName);
            SimpleFeatureCollection orgnlFeatureCollection = orgnlFeatureSource.getFeatures();

            // 좌표계 정의
            // KML의 기본 좌표계는 EPSG:4326
            // OpenLayers에서 사용하는 좌표계는 EPSG:3857
            CoordinateReferenceSystem orgnlCRS = orgnlFeatureSource.getSchema().getCoordinateReferenceSystem();
            
            // EPSG:3857 좌표계를 변환
            // true를 통해 위경도 순서([lat,lon] or [lon,lat])를 CRS에 맞춰 자동 변경
            CoordinateReferenceSystem targetCRS = CRS.decode("EPSG:4326", true);
            
            // 원본 좌표계를 목표 좌표계로 변환
            // true를 통해 정확하지 일치하지 않는 위치더라도 최대한 비슷한 위치로 강제 변환
            MathTransform transform = CRS.findMathTransform(orgnlCRS, targetCRS, true);
            
            // KML(XML 기반) 파일을 생성하기 위한 docFactory(빈 문서) 책체를 생성 
            DocumentBuilderFactory documentFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder documentBuilder = documentFactory.newDocumentBuilder();
            Document kmlDocument = documentBuilder.newDocument();

            // 생성된 XML 파일(newDocument)을 KML 문서화하기 위해 네임스페이스 추가
            Element kmlElement = kmlDocument.createElementNS("http://www.opengis.net/kml/2.2", "kml");
            kmlDocument.appendChild(kmlElement);

            Element documentElement = kmlDocument.createElement("Document");
            kmlElement.appendChild(documentElement);
            
            // <kml xmlns="http://www.opengis.net/kml/2.2">
            // 	<Document>
            // 	</Document>
            // </kml>
            
         // Collection에 저장하기 위해 FeatureInterator를 사용해 개별 Feature의 정보를 조회
            try (FeatureIterator<SimpleFeature> features = orgnlFeatureCollection.features()) {
               
            	// 다음 Feature가 있을 경우(마지막 Feature까지), 차례로 조회
            	while (features.hasNext()) {
                    SimpleFeature feature = features.next();
                    
                    // kml 파일에 해당 속성을 부여하기 위한 속성명 추가
                    Element placemark = kmlDocument.createElement("Placemark");
                    documentElement.appendChild(placemark);

                    Element name = kmlDocument.createElement("name");
                    name.setTextContent(String.valueOf(feature.getAttribute(0)));
                    placemark.appendChild(name);

                    // 해당 shp 파일에서 확인할 수 있는 추가적인 데이터 (ex.침수심) 등을 정의하기 위한 속성
                    Element extendedData = kmlDocument.createElement("ExtendedData");
                    placemark.appendChild(extendedData);
                    
                    for (Property property : feature.getProperties()) {
                        if (!(property.getValue() instanceof Geometry)) {
                            Element data = kmlDocument.createElement("Data");
                            data.setAttribute("name", property.getName().toString());
                            
                            Element value = kmlDocument.createElement("value");
                            value.setTextContent(String.valueOf(property.getValue()));
                            data.appendChild(value);
                            
                            extendedData.appendChild(data);
                        }
                    }
                    
                    // 원본 GeoMetry 좌표계를 EPSG:4326으로 변환
                    // KML은 무조건 EPSG:4326 기반으로 작동
                    Geometry geometry = (Geometry) feature.getDefaultGeometry();
                    geometry = JTS.transform(geometry, transform);
                    
                    // 각 Feature의 지리정보를 XML에 추가
                    if (geometry instanceof Polygon || geometry instanceof MultiPolygon) {
                        Element multiGeometry = kmlDocument.createElement("MultiGeometry");
                        placemark.appendChild(multiGeometry);

                        for (int i = 0; i < geometry.getNumGeometries(); i++) {
                            Geometry geom = geometry.getGeometryN(i);
                            
                            Element polygon = kmlDocument.createElement("Polygon");
                            multiGeometry.appendChild(polygon);

                            Element outerBoundaryIs = kmlDocument.createElement("outerBoundaryIs");
                            polygon.appendChild(outerBoundaryIs);

                            Element linearRing = kmlDocument.createElement("LinearRing");
                            outerBoundaryIs.appendChild(linearRing);

                            Element coordinates = kmlDocument.createElement("coordinates");
                            StringBuilder coordStr = new StringBuilder();

                            for (Coordinate coord : geom.getCoordinates()) {
                                coordStr.append(coord.x).append(",").append(coord.y).append(" ");
                            }
                            coordinates.setTextContent(coordStr.toString().trim());
                            linearRing.appendChild(coordinates);
                        }
                    }
            	}
            }
            
            // XML 형식에 맞춰 들여쓰기 및 형식을 적용
            Transformer transformer = TransformerFactory.newInstance().newTransformer();
            transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            transformer.setOutputProperty(OutputKeys.METHOD, "xml");
            transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");

            // XML 형식에 맞춘 폼을 적용하여 StringWriter에 저장
            transformer.transform(new DOMSource(kmlDocument), new StreamResult(stringWriter));
        } catch (FileNotFoundException e) {
            log.error(e.toString());
        } catch (IOException e) {
        	log.error(e.toString());
        } finally {
            // 변환 과정에서 GeoTools가 사용한 dataStore 자원을 해제
            if (dataStore != null) {dataStore.dispose();}

            // 임시 디렉토리가 남아있다면 해당 폴더 삭제
            if (tempDir != null && tempDir.exists()) {deleteTempDir(tempDir);}
        }
        
        // writer에 저장되어있는 GeoJSON을 문자열로 변환하여 리턴
        return stringWriter.toString();
    }
    
    /**
	 * 임시 디렉토리 생성 및 inputFile 저장 SERVICE
	 * 
	 * @author 최준규
	 * @since 2025.08.06
	 * @param MultipartFile inputFile
	 */
    
    private File createTempDir(MultipartFile inputFile) throws IOException {
    	String orgnlFileNm = inputFile.getOriginalFilename();
    	File uploadedFile = null;
    	
    	// 원본 파일명이 NULL일 경우, 예외 처리
    	if (orgnlFileNm == null) {throw new IllegalArgumentException();}
    	
    	// 파일명에 허용되지 않은 문자열이 있을 경우, 예외 처리
    	if (orgnlFileNm.contains("..") || orgnlFileNm.contains("/") || orgnlFileNm.contains("\\")) {throw new SecurityException();}
    	
    	try {
    		// 임시 디렉토리 생성
    		File tempDir = Files.createTempDirectory("shp_temp_upload_").toFile();
    		
    		// 파일명 검증 이후, 임시 디렉토리에 임시 파일 생성
    		uploadedFile = new File(tempDir, inputFile.getOriginalFilename());
    		
    		// 해당 파일 복사
    		copyMultipartFile(inputFile, uploadedFile);
    	} catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (NullPointerException e) {
			log.error(e.toString());
		}
    	
    	return uploadedFile;
    }
    
    /**
	 * 임시 디렉토리 삭제 SERVICE
	 * 
	 * @author 최준규
	 * @since 2025.08.06
	 * @param File file
	 */
    
    private void deleteTempDir(File file) throws IOException {
    	try {
    		// 디렉토리일 경우, 내부의 파일을 삭제
    		if (file.isDirectory()) {
    			
    			// 내부 파일의 리스트를 배열로 생성
    			File[] files = file.listFiles();
    			
    			// 파일이 존재할 경우 계속적으로 해당 메소드를 호출
    			if (files != null) {
    				for (File delFile : files) {
    					deleteTempDir(delFile);
    				}
    			}
     		}
    		if (!file.delete()) {
    			log.error("TempDir delete Fail: " + file.getAbsolutePath());
    		}
    	} catch (SecurityException e) {
    		log.error(e.toString());
        } catch (IOException e) {
            // I/O 문제 발생 시
        	log.error(e.toString());
        }
    }
    
    /**
	 * 파일 복사 SERVICE
	 * 
	 * @author 최준규
	 * @since 2025.08.06
	 * @param MultipartFile inputFile
	 * @param File outputFile
	 */
    
	public static void copyMultipartFile(MultipartFile inputFile, File outputFile) throws IOException {
        try(
        	InputStream inputStream = inputFile.getInputStream();
        	OutputStream outputStream = new FileOutputStream(outputFile);
        ){
        	// IO 처리를 위한 버퍼 생성 (8192byte = 8kb)
        	byte[] buffer = new byte[8192];
            int fileLength;
            
            // inputFile을 복사하여 저장
            while ((fileLength = inputStream.read(buffer)) > 0) {
            	outputStream.write(buffer, 0, fileLength);
            }
            
            inputStream.close();
            outputStream.close();
        } catch (IOException e) {
        	throw e;
        }
    }

	/**
	 * Zip파일 압축 해제 SERVICE
	 * 
	 * @author 최준규
	 * @since 2025.08.06
	 * @param File zipFile
	 * @param File targetDir
	 */
	
    public void unzip(File zipFile, File targetDir) throws IOException {
    	// IO 처리를 위한 버퍼 생성 (1024byte = 1kb)
        byte[] buffer = new byte[1024];
        
        // zipFileList : 원본 압축 파일
        // unzipFileList : 압축 해제된 파일의 리스트

        // 입력된 zipFile을 stream 형식으로 처리 (입력 순서대로 처리)
        try (ZipInputStream zipFileList = new ZipInputStream(new FileInputStream(zipFile))) {
            ZipEntry zipEntry;
            
            // zipFileList에 남은 목록이 없을 때까지 반복
            while ((zipEntry = zipFileList.getNextEntry()) != null) {
            	
            	// targetDir(임시 폴더)와 zipEntry의 파일명을 이용해 출력 파일 생성
                File outFile = new File(targetDir, zipEntry.getName());
            	
                // 입력 파일의 정상적인 경로를 탐지
            	String nmlTargetDir = targetDir.getCanonicalPath();
            	String nmlFile = outFile.getCanonicalPath();
            	
            	// 비정상적인 경로를 호출할 경우, 예외 처리
            	if(!nmlFile.startsWith(nmlTargetDir + File.separator)) {
            		throw new IOException();
            	}
            	
            	// Zip 파일 내부에 디렉토리가 존재할 경우, 예외 처리
                if (zipEntry.isDirectory()) {
                    if (!outFile.isDirectory() && !outFile.mkdirs()) {
                        throw new IOException();
                    }
                    continue;
                }
                
                // 파일 데이터를 가져와 임시 폴더의 대상 파일로 복사
                try (FileOutputStream unzipFileList = new FileOutputStream(outFile)) {
                    int fileLength;
                    while ((fileLength = zipFileList.read(buffer)) > 0) {
                    	unzipFileList.write(buffer, 0, fileLength);
                    }
                }
                
                // 메모리 해제를 위한 Entry 해제 (선택)
                zipFileList.closeEntry();
            }
        } catch (IOException e) {
        	log.error(e.toString());
        	throw e;
        }
    }
}
