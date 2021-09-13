<!doctype html>
<html>

<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Style -->
  <% _.forEach(styles, function(style) { %>
  <link rel="stylesheet" href="<%- style %>"></link>
  <% }); %>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.min.css"></link>

  <!-- Scripts -->
  <% _.forEach(scripts, function(script) { %>
  <script type="text/javascript" src="<%- script %>"></script>
  <% }); %>
  <script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/twitter-bootstrap/2.3.2/js/bootstrap.min.js"></script>


</head>

<body>
<%= content %>
</body>

</html>
