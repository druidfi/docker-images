<html>
<head>
    <title>Drupal placeholder</title>
    <style>
        * {
            text-align: center;
        }
    </style>
</head>
<body>
<h1>This would be your Drupal webroot: <?= __DIR__ ?></h1>

<div>
<?php

phpinfo(INFO_GENERAL | INFO_ENVIRONMENT);

?>
</div>
</body>
</html>
