
<%@page contentType="text/html" pageEncoding="UTF-8"
        import="com.mongodb.BasicDBObject"
        import="com.mongodb.DB"
        import="com.mongodb.DBCollection"
        import="com.mongodb.DBCursor"
        import="com.mongodb.MongoClient"
        import="java.net.UnknownHostException"
        import="com.mongodb.DBObject"
        import="com.mongodb.Mongo"
        import="java.util.Date"
        import="com.mycompany.mavenproject1.dconnect"
        %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
      /* NOTE: The styles were added inline because Prefixfree needs access to your styles and they must be inlined if they are on local disk! */
      @import url(https://fonts.googleapis.com/css?family=Exo:100,200,400);
@import url(https://fonts.googleapis.com/css?family=Source+Sans+Pro:700,400,300);

body{
	margin: 0;
	padding: 0;
	background: #fff;

	color: #fff;
	font-family: Arial;
	font-size: 12px;
}

.body{
	position: absolute;
	top: -20px;
	left: -20px;
	right: -40px;
	bottom: -40px;
	width: auto;
	height: auto;
	background-image: url('2.jpg');
	background-size: cover;
	-webkit-filter: blur(5px);
	z-index: 0;
}

.grad{
	position: absolute;
	top: -20px;
	left: -20px;
	right: -40px;
	bottom: -40px;
	width: auto;
	height: auto;
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(0,0,0,0)), color-stop(100%,rgba(0,0,0,0.65))); /* Chrome,Safari4+ */
	z-index: 1;
	opacity: 0.7;
}

.header{
	position: absolute;
	top: calc(50% - 35px);
	left: calc(30% - 255px);
	z-index: 2;
}

.header div{
	float: left;
	color: #fff;
	font-family: 'Exo', sans-serif;
	font-size: 35px;
	font-weight: 200;
}

.header div span{
	color: #5379fa !important;
}

.login{
	position: absolute;
	top: calc(30% - 75px);
	left: calc(60% - 50px);
	height: 150px;
	width: 350px;
	padding: 10px;
	z-index: 2;
}

.login input[type=text]{
	width: 250px;
	height: 30px;
	background: transparent;
	border: 1px solid rgba(255,255,255,0.6);
	border-radius: 2px;
	color: #fff;
	font-family: 'Exo', sans-serif;
	font-size: 16px;
	font-weight: 400;
	padding: 4px;
}

.login input[type=password]{
	width: 250px;
	height: 30px;
	background: transparent;
	border: 1px solid rgba(255,255,255,0.6);
	border-radius: 2px;
	color: #fff;
	font-family: 'Exo', sans-serif;
	font-size: 16px;
	font-weight: 400;
	padding: 4px;
	margin-top: 10px;
}

.login input[type=button]{
	width: 260px;
	height: 35px;
	background: #fff;
	border: 1px solid #fff;
	cursor: pointer;
	border-radius: 2px;
	color: #a18d6c;
	font-family: 'Exo', sans-serif;
	font-size: 16px;
	font-weight: 400;
	padding: 6px;
	margin-top: 10px;
}

.login input[type=button]:hover{
	opacity: 0.8;
}

.login input[type=button]:active{
	opacity: 0.6;
}

.login input[type=text]:focus{
	outline: none;
	border: 1px solid rgba(255,255,255,0.9);
}

.login input[type=password]:focus{
	outline: none;
	border: 1px solid rgba(255,255,255,0.9);
}

.login input[type=button]:focus{
	outline: none;
}

::-webkit-input-placeholder{
   color: rgba(255,255,255,0.6);
}

::-moz-input-placeholder{
   color: rgba(255,255,255,0.6);
}
    </style>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/prefixfree/1.0.7/prefixfree.min.js"></script>
    </head>
    <body>
        <%
            String submit=request.getParameter("Submit");
            if(submit!=null){
                dconnect mymongo=dconnect.createInstance();
                DBCollection collection=mymongo.getCollection("users");
                
                String fname=request.getParameter("fName");
                String lname=request.getParameter("lName");
                String age=request.getParameter("Age");
                String gtag=request.getParameter("gTag");
                String gender=request.getParameter("Gender");
                String gameGenre=request.getParameter("gameGenre");
                String platform=request.getParameter("Platform");
                String playHours=request.getParameter("playHours");
                
                
                BasicDBObject doc=new BasicDBObject();
                doc.append("$set", new BasicDBObject().append("First Name",fname)
                        .append("Last Name",lname)
                        .append("Age", age)
                        .append("GamerTag",gtag)
                        .append("Gender",gender)
                        .append("Genre",gameGenre)
                        .append("Platform",platform)
                        .append("Play Hours",playHours));
                
                BasicDBObject searchQuery = new BasicDBObject().append("_id",session.getAttribute("_id"));
                
                collection.update(searchQuery, doc);
                              
                               
                response.sendRedirect("dashboard.jsp");
                
            }
        %>
        
        <div class="body"></div>
		<div class="grad"></div>
		<div class="header">
                    <div>Fill in your details & <br><span>Start receiving suggestions</span></div>
		</div>
		<br>
		<div class="login">
        
        <form action="form.jsp" method="POST">
            First Name : <input type="text" name="fName" value="" /><br><br>
            Last Name : <input type="text" name="lName" value="" /><br><br>
            Age : <input type="text" name="Age" value="" /><br><br>
            Gamertag : <input type="text" name="gTag" value="" /><br><br>
            Gender : <select name="Gender">
                <option>Male</option>
                <option>Female</option>
                <option>Other</option>
            </select><br><br>
            Favorite Game Genre : <select name="gameGenre">
                <option>Action</option>
                <option>Adventure</option>
                <option>Casual</option>
                <option>Indie</option>
                <option>Massively Multiplayer</option>
                <option>Racing</option>
                <option>RPG</option>
                <option>Simulation</option>
                <option>Sports</option>
                <option>Strategy</option>
            </select><br><br>
            Preferred Platform of choice: <select name="Platform">
                <option>PC</option>
                <option>Xbox</option>
                <option>Playstation</option>
                <option>Nintendo</option>
            </select><br><br>
            Daily play time(hrs) : <input type="text" name="playHours" value="" /><br><br>
            <input type="submit" name="Submit" value="Submit">
        </form>
                </div>
                <script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
    </body>
</html>
