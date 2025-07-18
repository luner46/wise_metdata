<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>metdata</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="Pragma" content="no-cache"/>
	<meta http-equiv="Cache-Control" content="No-Cache"/>
	<link rel="stylesheet" type="text/css" href="/css/jquery-ui.min.css" />
	<link rel="stylesheet" type="text/css" href="/css/layout.css" />
	
	<script type="text/javascript" src="/js/plugin/ol_4/ol.js" ></script>
	<script type="text/javascript" src="/js/plugin/ol_3/proj4.js"></script>
	
	<link rel="stylesheet" type="text/css" href="/js/plugin/ol_4/ol.css" />
	<link rel="stylesheet" type="text/css" href="/js/plugin/jquery/jquery-ui.css" />
	
	<script src="/js/component/common_gis.js"></script>
	<script src="/js/plugin/jquery/jquery-1.12.4.min.js"></script>
	<script src="/js/plugin/jquery/jquery-ui.min.js"></script>
	<script src="/js/plugin/highcharts/highcharts.js"></script>
	<script type="text/javascript" src="/js/plugin/jquery/jquery.bxslider.min.js"></script>
</head>
<body>

<div id="content-wrap">
    <header>
        <nav>
            <ul>
                <li><a href="/modGisMeta/modGisMeta.do" title="GIS메타정보">GIS메타정보</a></li>
                <li><a href="/modStnInfo/modStnInfo.do" title="GIS관측소제원">GIS관측소제원</a></li>
                <li><a href="/modStnRn/modStnRn.do" title="GIS관측소강우">GIS관측소강우</a></li>
                <li><a href="/modRnCalendar/modRnCalendar.do" title="강우캘린더">강우캘린더</a></li>
                <li><a href="/modFloodQc/modFloodQc.do" title="홍수위험지도검수">홍수위험지도검수</a></li>
            </ul>
        </nav>
    </header>