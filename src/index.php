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
	<script src="media/flot/jquery.flot.js"></script>
	<script src="media/bootstrap.js"></script>
	<script type="text/x-mathjax-config">
		MathJax.Hub.Config({
			"tex2jax" : { "inlineMath" : [['$','$'], ['\\(','\\)']] },
			"HTML-CSS" : { "scale" : 85 }
		});
	</script>
	<script src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>
	<?php processing_header(); ?>
</head>
<body>
	<?php require('navbar.inc'); ?>
	<div class="container">
		<div class="row">
			<div class="panel">
				<div class="panel-body">
				<strong>Projet géométrie algorithmique (INFO-F-420)</strong><br>
				20 avril 2014<br>
				Tim Lenertz, ULB
				</div>
			</div>
			
			</div>
			<?php $canvas = processing_canvas_id(); ?>
			<div style="float: right; margin-left: 20px;">
			<canvas id="<?= $canvas ?>"></canvas><br>
			<div class="btn-group" style="margin-bottom: 10px; margin-top: 5px;">
				<button class="btn btn-default" onclick="Processing.instances[0].loop()">Démarrer</button>
				<button class="btn btn-default" onclick="Processing.instances[0].noLoop()">Arrêter</button>
				<button class="btn btn-default" onclick="Processing.instances[0].reinit()">Réinitialiser</button>
			</div>
			<?php processing('demo.pde', $canvas); ?>
			</div>
			
			<p>Dans un espace qui comprend plusieurs objets géométriques animés, par <em>détection de collisions</em> on entend des techniques pour déterminer de façon dynamique des collisions entre les objets. Ceci est par exemple utilisé dans des simulations physiques, dans des jeux vidéo, et en robotique.</p>
			
			<p>En général on peut distinguer entre la détection de collisions <em>à posteriori</em> ou <em>à priori</em>. Dans le premier cas, on fait avancer la simulation dans des étapes qui représentent un petit intervalle de temps pendant lequel les objets ne se déplacent que très peu. Après on regarde s'il y a des objets qui s'intersectent. Si oui, on applique des lois cinétiques pour corriger la position et le vecteur de mouvement de ces objets.<br>
			La détection de collision <em>à priori</em>, d'autre part, essaye plutôt de prédire des collisions, de manière à ce que des intersection ne se produisent jamais. Cela est par exemple nécessaire quand on contrôle un objet réel comme un bras robotique.</p>
			
			<p>A cause de l'aspect temps réel de la détection de collisions, et du fait qu'on peut avoir des simulation avec un grand nombre d'objets complexes, on a besoin d'algorithmes efficaces pour détecter les collisions, et de structures de données correspondantes. Ce projet décrit un algorithme qui permet de <a href="pp.html">détecter l'intersection de deux polygones convexes</a>, et un qui permet de <a href="dmin.html">trouver la distance minimale de deux polygones convexes</a>. Les deux algorithmes fonctionnent en temps logarithmique par rapport au nombre de points $n$ et $m$ dans les deux polygones. Une implémentation triviale aurait une complexité d'au moins $O(n \times m)$.</p>
			
			<p>La détection de collision (ou de distance, etc.) de deux objets complexes nécessite un grand nombre de calculs, surtout pour une simulation tri-dimensionnelle. Parce qu'il y a souvent seulement un petit sous-ensemble des objets qui interagissent, il y a beaucoup de possibilités d'optimisation. Par exemple, on peut utiliser des <em>bounding box</em>, qui peuvent être un rectangle ou une sphère qui enveloppe un objet. Calculer une intersection de ces objets est beaucoup plus efficace et on sait que les objets ne peuvent d'intersecter seulement si les <em>bounding boxes</em> s'intersectent.<br>
			Une autre stratégie est de subdiviser l'espace en régions qui contiennent des objets qui peuvent s'intersecter entre eux, tandis qu'une intersection de deux objets de différentes régions peut être éliminée d'office.</p>
			
			<p>L'applet à droite montre un exemple d'une simulation avec détection de collision <em>à priori</em>. Le programme calcule la <a href="dmin.html">distance minimale des deux polygones convexes</a>, et applique une force de répulsion quand les objets sont proches l'un de l'autre, ou aux bords de l'écran.</p>
	</div>
</body>
</html>
