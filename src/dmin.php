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
			<div class="col-md-3">
				<ul class="list-group">
					<li class="list-group-item"><a href="#ebin"#>Elimination binaire</a></li>
					<li class="list-group-item"><a href="#iter"#>Phase itérative</a></li>
					<li class="list-group-item"><a href="#final"#>Phase finale</a></li>
					<li class="list-group-item"><a href="#applet"#>Applet</a></li>
				</ul>
			</div>
			<div class="col-md-8">
				<h1>Distance minimale</h1>
				<p>Un problème similaire est de trouver le segment $d$ de longueur minimale qui relie deux polygones convexes $P$ et $Q$. On suppose que ces polygones ne s'intersectent pas. $d$ peut relier les polygones soit en deux points, en un point et un segment, ou en deux segments (parallèles):</p>
				
				<p><img src="media/dpp.svg" width="180px" style="margin-right: 30px"><img src="media/dpl.svg" width="180px" style="margin-right: 30px"><img src="media/dll.svg" width="180px"></p>
				
				<p>Ceci peut être utilisé pour une détection <em>à priori</em> de collisions, puisque $|d|$ approche $0$ avant que les polygones commencent à s'intersecter. L'algorithme suivant permet de trouver $d$ en temps $O(\log n + \log m)$.</p>
				
				<p>D'abord, on calcule les couples de demi-droites $C_1$ et $C_2$ comme au chapitre précédent. Les demi-droites $C_1$ ($C_2$) ont $p_1$ ($q_1$) comme origine et couvrent complètement $Q$ ($P$). On déduit la polyligne $L_p$ de $P$, qui relie les deux points d'intersection $u$ et $t$ de $C_2$ et $P$, tel que $L_p$ est sur le même côte de $ut$ que $Q$. De la même façon, on trouve la polyligne $L_q$ de $Q$. ($L_p$ et $L_q$ ne sont pas liés aux polylignes $L_v$ et $L_w$ du chapitre précédent.) Cette étape peut être fait en temps logarithmique.</p>
				
				<p>Le segment $d$ va relier deux points/segments de $L_p$ et $L_q$. Afin de trouver $d$ en temps logarithmique, on utilise une procédure récursive comme au chapitre précédent, qui élimine à chaque étape une moitié de $L_p$ et/ou $L_q$.</p>
				
				<h2 id="ebin">Algorithme d'élimination binaire</h2>
				<p><img src="media/dmin.svg" align="right" width="330px">On pose $p_*$ et $q_*$ tel que $L_p = \{ p_1, p_2, ..., p_n \}$, et $L_q = \{ q_1, q_2, ..., q_m \}$, tous les deux en sens horlogique. Soit $i = \lfloor \frac{n}{2} \rfloor$ et $j = \lfloor \frac{m}{2} \rfloor$. Soit $m$ le segment qui relie $p_i$ et $q_j$.<br>
				On définit les angles $\alpha', \alpha'', \beta', \beta''$ en sens anti-horlogique, dans $[0, 2\pi[$. Si $m$ pointe dans l'intérieur du polygone, l'angle devient négatif.
				<div class="formula">
					$\alpha' = \angle(p_{i-1}p_{i}, m)$<br>
					$\alpha'' = \angle(m, p_{i}p_{i+1})$<br>
					$\beta' = \angle(m, q_{i}q_{i+1})$<br>
					$\beta'' = \angle(q_{i-1}q_{i}, m)$
				</div>
				Par convexité de $P$ et $Q$, on a:
				<ol>
					<li>$\alpha' + \alpha'' \geq \pi$, et donc $\alpha' \geq \frac{\pi}{2}$ ou $\alpha'' \geq \frac{\pi}{2}$. De même pour $\beta'$ et $\beta''$.</li>
					<li>$\alpha' + \beta' \leq \pi$ implique $\alpha' < \beta''$</li>
					<li>$\alpha' + \beta' > \pi$ ou $\alpha'' + \beta'' > \pi$</li>
				</ol></p>
				
				<h2 id="iter">Phase itérative</h2>
				<p><br clear="right">L'algorithme est répété tant que $|L_p| > 2$ ou $|L_q| > 2$. Pour chaque itération, on distingue les cas suivants:</p>
				
				<p><strong>Cas 1:</strong> $|L_p| = 1$ ($p_i = p_1$).<br>
				Si $\beta' \geq \frac{\pi}{2}$, $L_q \leftarrow \{ q_j, q_{j+1}, ..., q_m \}$. Si $\beta'' \geq \frac{\pi}{2}$, $L_q \leftarrow \{ q_1, ..., q_{j-1}, q_{j} \}$<br>
				Le cas où $|L_q| = 1$ est traité de façon symétrique. Théorème <strong>1</strong> garanti qu'au moins une des deux conditions est toujours vraie. Si $\beta' \geq \frac{\pi}{2}$, alors on $d(p_1, q_j) < d(p_1, q \in q_1...q_j)$. Donc l'opération n'élimine pas de point de $Q$ qui formerait la distance minimale.</p>
				
				<p><strong>Cas 2:</strong> $|L_p| = 2$ ($p_i = p_2$).<br>
				<p></p><img src="media/dmin2.svg" width="280px" style="margin-right: 20px"><img src="media/dmin2_.svg" width="280px"></p>
				<p>Si $\alpha' > 0$, exécuter les étapes suivantes:
				<ol>
					<li>Si $\alpha' + \beta' > \pi$: Si $\alpha' \geq \frac{\pi}{2}, L_p \leftarrow \{ p_2 \}$. Si $\beta' \geq \frac{\pi}{2}, L_q \leftarrow \{ q_j, ... \}$</li>
					<li>Si $\beta'' \geq \frac{\pi}{2}$, $L_q = \{ ..., q_j \}$</li>
					<li>Si $\alpha' < \beta'' < \frac{\pi}{2}$: Si la projection orthogonale de $q_j$ sur le segment $p_{1}p_{2}$ existe: $L_q \leftarrow \{ ..., q_j \}$. Sinon, $L_p \leftarrow \{ p_1 \}$.</li>
				</ol>
				Les étapes <strong>1</strong> et <strong>2</strong> sont justifiés par le même raisonnement qu'au cas 1. Pour l'étape <strong>3</strong>: Si la projection orthogonale $q_{j}'$ existe, alors on a $d(p_{1}p_{2}, q \in q_{1}...q_{j}) > d(q_{j}, q_{j}')$. (Puisque $\beta'' > \alpha'$.) Si le projection n'existe pas, alors $d(p_{1}p_{2}, q) > d(q_{j}, q_{j}')$ pour les mêmes points $q$.</p>
				<p>Si $\alpha' < 0$: $L_p \leftarrow \{ p_1 \}$. De plus, si $\beta' \geq \pi$, $L_q \leftarrow \{ q_j, ... \}$, et si $\beta'' \geq \pi$,  $L_q \leftarrow \{ ..., q_j \}$.</p>
				
				<p><strong>Cas 3:</strong> Les deux polylignes contiennent au moins trois points. On distingue encore deux cas:</p>
				<p>Si tous les 4 angles sont positifs, exécuter les étapes suivantes:
				<ol>
					<li>Si $\alpha' + \beta' > \pi$: Si $\alpha' \geq \frac{\pi}{2}$, $L_q \leftarrow \{ p_i, ... \}$, et si $\beta' > \frac{\pi}{2}$, $L_q \leftarrow \{ q_j, ... \}$.</li>
					<li>Si $\alpha'' + \beta'' > \pi$: Si $\alpha'' \geq \frac{\pi}{2}$, $L_p \leftarrow \{ ..., p_i \}$, et si $\beta'' \geq \frac{\pi}{2}$, $L_q \leftarrow \{ ..., q_j \}$.</li>
				</ol></p>
				<p>Si un angle est négatif (par exemple $\alpha' \leq 0$):<br>
				$L_p \leftarrow \{ ..., p_i \}$. En plus, si $\beta' \geq \pi$, $L_q \leftarrow \{ q_j, ... \}$ et si $\beta'' \geq \pi$, $L_q \leftarrow \{ ..., q_j \}$.</p>
				
				<p>On voit que à chaque étape, $L_q$ et/ou $L_p$ sont réduits à la moitié, ce qui justifie la complexité logarithmique de l'algorithme. A la fin, $L_p$ et $L_q$ contiennent chacun soit un ou deux points. La phase finale va en déduire le segment $d$ (distance minimale des polygones), en temps constant.</p>

				<h2 id="final">Phase finale</h2>
				<p>$|L_p| = 1$ et $|L_q| = 1$, $d = p_{1}q_{1}$.</p>
				
				<p>$|L_p| = 2$ et $|L_q| = 1$: $d$ peut être $p_{1}q_{1}$, $p_{2}q_{1}$, ou bien $q_{1}'q_{1}$, avec $q_{1}'$ la projection orthogonale de $q_{1}$ sur $p{1}p{2}$ (si elle existe). On choisit le segment de longueur minimale. Cas symétrique si $|L_p| = 1$ et $|L_q| = 2$.</p>
				
				<p>$|L_p| = 2$ et $|L_q| = 2$: Similaire au cas 2, on considère tous les segments qui relient les $4$ points, et les $\leq 4$ segments formés par projections orthogonales, et on choisit le segment de longueur minimale.</p>
				
				<h2 id="applet">Applet</h2>
				<p>L'applet suivant implémente l'algorithme décrit.</p>
				<p><?php processing('polygonsDistance.pde'); ?></p>
			</div>
		</div>
	</div>
</body>
</html>
