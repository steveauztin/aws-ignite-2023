<!DOCTYPE html>
<html>
  <head>
    <title>AWS Tech Fundamentals Bootcamp</title>
    <link href="style.css" media="all" rel="stylesheet" type="text/css" />
    <meta http-equiv="refresh" content="10,URL=/rds.php" />
  </head>
  <body>
    <div id="wrapper">
      <?php include('menu.php'); ?>

      <?php 
        $endpoint = $_POST['endpoint'];
        $endpoint = str_replace(":3306", "", $endpoint);
        $database = $_POST['database'];
        $usernanem = $_POST['username'];
        $password = $_POST['password'];

        // $mysql_command = "mysql -u $usernanem -p'$password' -h $endpoint $database < sql/addressbook.sql";
        $mysql_command = "mysql -u $usernanem -p'$password' -h $endpoint < sql/addressbook.sql";

        $connection = mysqli_connect($endpoint, $usernanem, $password);

        if (mysqli_connect_errno()) echo "Failed to connect to MySQL: " . mysqli_connect_error();

        // $databaseConnect = mysqli_select_db($connection, $database);

        echo "<br />";
        echo "<p>Executing Command: $mysql_command</p>";
        echo exec($mysql_command);
        
        echo "<br />";
        echo "<p>Writing config out to rds.conf.php </p>";
        $rds_conf_file = 'rds.conf.php';
        $handle = fopen($rds_conf_file, 'w') or die('Cannot open file:  '.$rds_conf_file);
        $data = "<?php \$DB_SERVER='" . $endpoint . "'; \$DB_DATABASE='" . $database . "'; \$DB_USERNAME='" . $usernanem . "'; \$DB_PASSWORD='" . $password . "'; ?>";
        fwrite($handle, $data);
        fclose($handle);

        mysqli_close($connection);
        echo "<br />";
        echo "<br />";
        echo "<p><i>Redirecting to rds.php in 10 seconds (or click <a href=rds.php>here</a>)</i></p>";
      ?>
    </div>
  </body>
</html>