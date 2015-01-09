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
			<div class="col-md-3">
				<ul class="list-group">
					<li class="list-group-item"><a href="#unibimod"#>Unimodale / bimodale</a></li>
					<li class="list-group-item"><a href="#dior"#>Distances orientées</a></li>
					<li class="list-group-item"><a href="#dior"#>Algorithme IGL</a></li>
					<li class="list-group-item"><a href="#applet"#>Applet</a></li>
				</ul>
			</div>
			<div class="col-md-8">
				<h1>Intersection droite–polygone convexe</h1>
				<h2 id="unibimod">Fonctions unimodales et bimodales</h2>
				<p>Une fonction $f : \{1, 2, .., n\} \rightarrow \mathbb{R}$ est <em>unimodale</em>, s'il existe un entier $m \in [1, n]$ tel que $f$ est strictement croissante (ou décroissante) en $[1, m]$, et strictement décroissante (ou croissante) en $[m + 1, n]$. Les deux extréma de la fonction peuvent être trouvés en temps logarithmique:</p>
				
				<p>En comparant $f(1)$ et $f(2)$, on peut déterminer si la première partie de $j$ est croissante ou décroissante. Au premier cas, $\min \{ f(1), f(n-1) \}$ est le minimum de $f$, et au deuxième cas, $\max \{ f(1), f(n-1) \}$ est le maximum. L'autre extremum $m$ de $f$ peut être trouvé par recherche dichotomique, en considérant sa fonction dérivée $f'(i) = f(i + 1) - f(i)$, qui est strictement positive en $[1, m[$ et strictement négative en $[m, n[$.</p>
				
				<p>Une fonction $f$ est <em>bimodale</em>, s'il existe un entier $r \in [1, n]$ tel que la séquence $f(r), f(r+1), ..., f(n), f(1), f(2), ..., f(r-1)$ est unimodale. En autre mots, une fonction est bimodale si elle peut être transformée en une fonction unimodale en appliquant un décalage circulaire modulo $n$ aux indices. Elle est donc composée de trois parties ($\nearrow \searrow \nearrow$ ou $\searrow \nearrow \searrow$) sur lesquelles elle est strictement monotone, et elle a deux points d'inflexion. En plus, pour la première forme, on a $f(1) < f(n)$, et pour la deuxième, $f(1) > f(n)$. Il est possible de trouver les extéma d'une fonction bimodale aussi en temps logarithmique: Soit $T$ la fonction de la droite qui rejoint $(1, f(1))$ et $(n, f(n))$
				<div class="formula">
					$T(x) = f(1) + \frac{x-1}{n-1}(f(n) - f(1))$
				</div>
				On distingue deux cas:
				<ul>
					<li>$f(1) \leq f(n)$: Si $f(2) \geq f(1)$, $f(1)$ est le minimum, et le maximum se trouve dans $f(2)...f(n)$, qui est unimodal. Si $f(2) < f(1)$, on défine la fonction $g(x) = \min \{ f(x), T(x) \}$. On a $\forall x, g(x) \leq f(n)$. Donc le maximum de $g$ ne peut pas être plus grand que $g(n)$, et donc $g$ est unimodal, et son minimum correspond à celui de $f$. Après avoir trouvé ce minimum $x$, le maximum peut être trouvé dans la séquence unimodale $f(x+1)...f(n)$.</li>
					<li>$f(1) \geq f(n)$: Situation inverse; Si $f(2) \leq f(1)$, $f(1)$ est le maximum, et le minimum de trouve dans $f(2)...f(n)$. Sinon, le minimum $x$ est celui de $g$, et le maximum est dans $f(0)...f(x-1)$.</li>
				</ul>
				
	
				<h2 id="dior">Bimodalité des distances orientés</h2>
				<p>Soit $\{ p_1, p_2, ..., p_{n} \}$ les points de $P$ en ordre horlogique. Soit $d(x, L)$ la distance orthogonale entre un point $x$ et la droite $L$. La <em>distance orientée</em> $h(x, L, v)$ par rapport au point $v$ est définie comme $d(x, L)$ si $x$ et $v$ se trouvent sur le même côté de $L$, et $-d(x, L)$ au cas contraire. Alors on peut montrer que $\forall v \notin L$, la fonction $f(i) = h(p_{i}, L, v)$ est bimodale:</p>
				
				<p><img src="media/hBimodal.svg" align="right" width="300px">Soit $p_k$ le point pour lequel $f$ est minimal. ($p_7$ sur le graphique) Pour que $f$ soit bimodale, il suffit de montrer que la séquence $f(k), f(k + 1), ..., f(k - 1)$ (indices modulo $n$) est unimodale.<br>
				Soit $r$ le verteur directeur de $L$, orienté tel que $\angle(r, p_{k}p_{k+1}) < \pi$. Tous les angles sont prises en sens anti-horlogigue, dans $[0, 2\pi[$. Soit $a_i = \angle(r, p_{i}p_{i+1})$ et $b_i = \angle(p_{i}p_{i+1}, p_{i-1}p_{i})$. Les relations suivantes sont vrai pour tout $i$:
				<div class="formula">
					$f(i + 1) = f(i) + |p_{i}p_{i+1}| \sin a_i$<br>
					$a_{i+1} = a_i - b_{i+1}$
				</div>
				Comme $P$ est convexe, tous $\forall i, b_i < \pi$. En plus $\sum b_i = 2\pi$. Par conséquent, la séquence $\sin a_k, \sin a_{k+1}, ..., \sin a_{k-1}$ est positive, puis négative. Donc $f(k), f(k + 1), ..., f(k - 1)$ est unimodale, et $f$ est bimodale.</p>
				
				<br clear="right">
				<h2 id="igl">Algorithme <em>IGL</em></h2><a href="igl"></a>
				<p>On peut trouver les points d'intersection entre $L$ et $P$ en cherchant les extréma de $f$, et donc en temps $O(\log n)$. On suppose d'abord que $p_1 \notin L$. Ceci ne nuit pas à la généralité, car on peut décaler les indices des points sinon. On a que $f(i) = h(p_i, L, p_1)$ est bimodale, et on peut trouver le point $p_w$ pour lequel $f(w)$ est minimal en temps logarithmique. $P$ et $L$ ne s'intersectent seulement si $f(w) \leq 0$:</p>
				
				<p>Si $f(w) > 0$, tous les points de $P$ se trouveraient sur le même côté $L$ (car tous les points sont du même côté de $L$ que $p_1$), et il n'y a donc pas de point d'intersection. Si $f(w) = 0$, le point $p_w$ se trouve sur $L$ et est le point d'intersection unique: Tous les autres points sont plus éloignés de $L$ et sont sur un même côté. Ces deux conditions sont suffisantes et nécessaires.</p>
				
				<p>Il reste le cas $f(w) < 0$, pour lequel il y a deux points d'intersection, sur deux segments $(p_i, p_{i+1})$ du polygone. Pour ces deux segments, leurs deux points se trouvent sur les côtés opposés de $L$ (c.à.d. $f(i) \times f(i+1) < 0$). Comme on sait que $w$ est le minimum de la fonction unimodale $f$, on peut trouver les deux segments par recherche dichotomique sur les séquences $f(w), f(w+1), ..., f(n)$, et $f(1), f(2), ...., f(w)$ respectivement. Le point d'intersection de $L$ et du segment peut ensuite être déterminé en temps constant.</p>
				
				<h2 id="applet">Applet</h2>
				<p>Le programme suivant calcule les points d'intersection et $L$ et $P$. Les objets peuvent être déplacés avec la souris. Le graphe montre la fonction $f(i)$ (bimodale) en bleu, ainsi que $g(i)$ (unimodale) en vert, quand elle est différente. Le programme utilise la méthode décrite pour trouver les points d'intersection.</p>
				<?php $canvas = processing_canvas_id(); ?>
				<canvas id="<?= $canvas ?>" style="display: inline-block"></canvas>
				<div id="linePolygonIntersectionPlot" style="display: inline-block"></div>
				<script>
				document.linePolygonIntersectionPlot = $.plot("#linePolygonIntersectionPlot", [], {
					"yaxis" : { "min" : -300, "max" : 300, "ticks" : 1, "tickFormatter" : function() { return ''; } },
					"xaxis" : { "tickDecimals" : 0, "tickSize" : 1, "tickFormatter" : function(i) { return i + 1; } },
					"series" : { "lines" : { "show" : true }, "points" : { "show" : false }, "shadowSize" : 0 },
					"colors" : [ "green", "blue" ]
				});
				</script>
				<?php processing('linePolygonIntersection.pde', $canvas); ?><
			</div>
		</div>
	</div>
</body>
</html>
