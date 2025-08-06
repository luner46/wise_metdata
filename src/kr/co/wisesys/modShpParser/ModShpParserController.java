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

@Controller
@RequestMapping(value={"/modShpParser/*"})
public class ModShpParserController {

    private final Logger log = LoggerFactory.getLogger(getClass());
    
    @Autowired
    ModShpParserService service;
    
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
    
    @RequestMapping(value="/modDisplayLayer.do")
	public String testLayer() {
		try {
			return "modShpParser/modDisplayLayer";
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
			return "../../error/error";
		} catch (NullPointerException e) {
			log.error(e.toString());
			return "../../error/error";
		}
	}

    @RequestMapping(value="/modShpToGeoJson.do")
    @ResponseBody
    public String modShpToGeoJson(@RequestParam MultipartFile file) throws IOException, FactoryException, TransformException {
    	log.info("GeoJSON Convert Start");
    	String resultGeoJSON = "";
    	try {
    		resultGeoJSON = service.convertToGeoJson(file);
            log.info("GeoJSON Convert Success");
        } catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (NullPointerException e) {
			log.error(e.toString());
		}
    	return resultGeoJSON;
    }
    
    @RequestMapping(value = "/modShpToKml.do")
    @ResponseBody
    public String modShpToKml(@RequestParam MultipartFile file) throws IOException, FactoryException, TransformException, ParserConfigurationException, TransformerException {
    	log.info("KML Convert Start");
    	String resultKML = "";
    	try {
    		resultKML = service.convertToKml(file);
            log.info("KML Convert Success");
        } catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (NullPointerException e) {
			log.error(e.toString());
		}
    	return resultKML;
    }
}
