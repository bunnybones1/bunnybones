<?php
    if ( $_SERVER['REQUEST_METHOD'] === 'POST' )
    {
        // Read the input from stdin
        $postText = trim(file_get_contents('php://input'));
    }

    $htmldoc = new DOMDocument;
    $htmldoc->loadHTML($postText);
    $file = $htmldoc->getElementsByTagName("file");
    $file_location = $file->item(0)->getAttribute("name");


    //$fp = fopen("assets/xml/settings.xml","w");
    $fp = fopen($file_location,"w");

    fwrite($fp,$postText);
    fclose( $fp );
?>