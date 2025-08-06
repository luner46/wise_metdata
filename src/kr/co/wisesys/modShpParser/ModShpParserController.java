package kr.co.wisesys.modShpParser;

import java.io.*;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;

import org.geotools.api.referencing.FactoryException;
import org.geotools.api.referencing.operation.TransformException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

/**
 * <pre>
 * @ClassName   : ModShpParserController.java
 * @Description : SHP 파일 변환 모듈 Controller
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

@Controller
@RequestMapping(value={"/modShpParser/*"})
public class ModShpParserController {

    private final Logger log = LoggerFactory.getLogger(getClass());
    
    @Autowired
    private ModShpParserService service;
    
    /**
	 * SHP 파일 변환 페이지
	 * 
	 * @author 최준규
	 * @since 2025.08.06
	 * @return shp 파일 변환 페이지 main view
	 */
    
    @RequestMapping(value="/modShpParser.do")
    public String modShpToKml () {
        try {
            return "modShpParser/modShpParser";
        } catch (IllegalArgumentException e) {
			log.error(e.toString());
			return "../../error/error";
		} catch (NullPointerException e) {
			log.error(e.toString());
			return "../../error/error";
		}
    }

	/**
	 * SHP > GeoJSON 변환 CONTROLLER
	 * 
	 * @author 최준규
	 * @since 2025.08.06
	 * @param MultipartFile file
	 * @return String resultGeoJSON
	 */
	
    @RequestMapping(value="/modShpToGeoJson.do")
    @ResponseBody
    public String modShpToGeoJson(@RequestParam MultipartFile file) throws IOException, FactoryException, TransformException {
    	String resultGeoJSON = "";
    	try {
    		resultGeoJSON = service.convertToGeoJson(file);
        } catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (NullPointerException e) {
			log.error(e.toString());
		}
    	return resultGeoJSON;
    }
    
    /**
	 * SHP > KML 변환 CONTROLLER
	 * 
	 * @author 최준규
	 * @since 2025.08.06
	 * @param MultipartFile file
	 * @return String resultKML
	 */
    
    @RequestMapping(value = "/modShpToKml.do")
    @ResponseBody
    public String modShpToKml(@RequestParam MultipartFile file) throws IOException, FactoryException, TransformException, ParserConfigurationException, TransformerException {
    	String resultKML = "";
    	try {
    		resultKML = service.convertToKml(file);
        } catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (NullPointerException e) {
			log.error(e.toString());
		}
    	return resultKML;
    }
}
