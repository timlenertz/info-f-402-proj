<?php

function processing_header() {
	$frameworkFiles = glob('framework/*.pde');
	$framework = '';
	foreach($frameworkFiles as $file) $framework .= file_get_contents($file) . "\n";
	$framework = json_encode($framework);
	
	echo <<<EOT
<script src="media/processing.js"></script>
<script 
<script>
	var frameworkJs = $framework;
</script>
EOT;
}

function processing_canvas_id() {
	static $counter = 0;
	return 'processing-canvas-' . ++$counter;
}

function processing($pde, $canvas = null) {
	$js = json_encode("\n\n" . file_get_contents($pde));
	
	if(is_null($canvas)) {
		$canvas = processing_canvas_id();
		echo '<canvas id="', $canvas, '"></canvas>';
	}
	
	echo <<<EOT
<script>
	var js = frameworkJs + $js;
	var procedure = Processing.compile(js);
	var canvas = document.getElementById("$canvas");
	var instance = new Processing(canvas, procedure);
</script>	
EOT;
}

?>
