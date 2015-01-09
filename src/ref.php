<?php
include_once 'processing.inc';
?>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>Détection de collisions</title>
	<link href="media/bootstrap.css" rel="stylesheet">
	<link href="media/style.css" rel="stylesheet">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<script src="media/jquery-2.1.0.min.js"></script>
	<script src="media/bootstrap.js"></script>
</head>
<body>
	<?php require('navbar.inc'); ?>
	<div class="container">
		<div class="row">
			<h1>Références</h1>
			<p><ul>
				<li><strong>Intersection of Convex Objects in Two and Three Dimensions</strong>. B. Chazelle &amp; D. P. Dobkin.<br>
				Journal of the Association for Computing Machinery, Vol. 34, No. 1. January 1987.</li>
				<li><strong>Detection Is Easier than Computation.</strong> B. Chazelle &amp; D. P. Dobkin<br>
				ACM 1980.</li>
				<li><strong>Computing the Extreme Distances between Two Convex Polygons.</strong> H. Edelsbrunner.<br>
				Institutes for Information Processing, Technical University of Graz. October 1982.</li>
			</ul></p>
			
			<p>Applets créés avec <a href="http://processingjs.org/" target="_blank">Processing.js</a><br>
			Rendu des formules mathématiques: <a href="http://www.mathjax.org/" target="_blank">MathJax</a><br>
			Graphe de la fonction bimodale: <a href="http://www.flotcharts.org/" target="_blank">Flot</a> plotting library<br>
			Layout CSS: <a href="http://getbootstrap.com/" target="_blank">Bootstrap</a><br>
			Figures créés avec <a href="http://www.geogebra.org/" target="_blank">GeoGebra</a>
			</p>
		</div>
	</div>
</body>
</html>
