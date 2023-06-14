<?php
echo "<meta http-equiv=\"refresh\" content=\"5,URL=/rds.php\" />";
?>
<h2>Address Book</h2>
<?php 
  //This is a simple address book example for testing with RDS
  include('rds.conf.php');

  /* Connect to MySQL and select the database. */
  $connection = mysqli_connect($DB_SERVER, $DB_USERNAME, $DB_PASSWORD);

  if (mysqli_connect_errno()) echo "Failed to connect to MySQL: " . mysqli_connect_error();

?>
<!-- Display table data. -->
<table border cellpadding=3>
  <tr>
    <th width=50>ID</th>
    <th width=100>Name</th>
    <th width=100>Phone</th>
    <th width=200>Email</th>
  </tr>
<?php
  $database = mysqli_select_db($connection, $DB_DATABASE);
  $result = mysqli_query($connection, "SELECT * FROM address ORDER BY name ASC");
  while($query_data = mysqli_fetch_row($result)) {
    echo "<tr>";
    echo "<td>",$query_data[0], "</td>",
         "<td>",$query_data[1], "</td>",
         "<td>",$query_data[2], "</td>",
         "<td>",$query_data[3], "</td>";
    echo "</tr>";
  }
?>
</table>
<!-- Clean up. -->
<?php

  mysqli_free_result($result);
  mysqli_close($connection);

?>