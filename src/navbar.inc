<?php
$page = $_SERVER['PHP_SELF'];
?>
<div class="container">
<div class="navbar navbar-inverse" style="margin-top: 20px">
	<div class="navbar-header">
	  <a class="navbar-brand" href="#">Projet géométrie algorithmique: <strong>Détection de collisions</strong></a>
	</div>
</div>
<div class="navbar navbar-inverse">
	<div class="container">
	  <ul class="nav navbar-nav">
		<li class="<?= ($page == 'index.php' ? 'active' : '') ?>"><a href="index.html">Introduction</a></li>
		<li class="<?= ($page == 'lp.php' ? 'active' : '') ?>"><a href="lp.html">Intersection droite–polygone</a></li>
		<li class="<?= ($page == 'pp.php' ? 'active' : '') ?>"><a href="pp.html">Intersection polygones</a></li>
		<li class="<?= ($page == 'dmin.php' ? 'active' : '') ?>"><a href="dmin.html">Distance minimale</a></li>
		<li class="<?= ($page == 'ref.php' ? 'active' : '') ?>"><a href="ref.html">Références</a></li>
	  </ul>
	</div>
</div>
</div>
