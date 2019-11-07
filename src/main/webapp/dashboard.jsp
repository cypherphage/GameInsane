<%@page contentType="text/html" pageEncoding="UTF-8"
        import="com.mongodb.BasicDBObject"
        import="com.mongodb.BasicDBList"
        import="com.mongodb.DB"
        import="com.mongodb.DBCollection"
        import="com.mongodb.DBCursor"
        import="com.mongodb.MongoClient"
        import="java.net.UnknownHostException"
        import="com.mongodb.DBObject"
        import="com.mongodb.Mongo"
        import="java.util.Date"
        import="com.mycompany.mavenproject1.dconnect"
        import="java.util.List"
        import="java.util.ArrayList"
    %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DASHBOARD</title>
        <style>
            #outer-grid {
                display: grid;
                grid-template-rows:300px 500px 200px;
            }
            #top-grid {
                display: grid;
                grid-template-columns:300px 1fr;
            }
            #top-side-grid{
                display: grid;
                grid-template-rows:200px 100px;
            }
            #in-between-grid{
                display: grid;
                grid-template-columns:500px 1fr;
            }
            #bottom-grid{
                display: grid;
                grid-template-columns:1fr;
            }
        </style>
    </head>
    
    <body>  
       <div id="outer-grid">
           <div id="top-grid">
               <img src="3.png">
               <div id="top-side-grid">
                   
                    <!--First Name and Last Name-->
                    <div style="background: #454448; text-align: left; color: white; font-family: 'Lucida Console', Monaco, monospace; padding: 30px; font-size: 70px">
                    <%  
                        //Connecting to database
                        dconnect mymongo=dconnect.createInstance();
                        DBCollection collection=mymongo.getCollection("users");
                
                        //Searching database        
                        DBCursor cursor = collection.find();               
                        cursor=collection.find(new BasicDBObject("_id", session.getAttribute("_id")));
                        
                        //Printing firstname and lastname
                        try {
                            while (cursor.hasNext()) {
                                DBObject object = cursor.next();
                                out.println(""+object.get("First Name") + "  " + (object.get("Last Name")));
                            }
                        }   
                        finally { cursor.close(); }
                
                    %>
                    </div>
                    
                    <!--Gamertag-->
                    <div style="background: #FF5722; text-align: center; color: whitesmoke; font-family: 'Lucida Console', Monaco, monospace; padding: 30px; font-size: 30px">
                    <%                 
                        //Searching database
                        cursor=collection.find(new BasicDBObject("_id", session.getAttribute("_id")));
                        
                        //Printing gamertags
                        try {
                            while (cursor.hasNext()) {
                                DBObject object = cursor.next();
                                out.println("WELCOME to GameinSane  --" + object.get("GamerTag"));
                            }
                        } 
                        finally { cursor.close(); }
                    %>
                    </div>
                </div>
            </div>
                    <div id="in-between-grid">
                        <!--left panel of middle grid-->
                        <div style="background: #03A9F4; text-align: left; color: white; font-family: 'Lucida Console', Monaco, monospace; padding: 50px; padding-left: 70px; font-size: 30px">
                        <div style="text-align: center ; font-size: 40px">
                         <%
                             out.println("THIS IS YOU  <br><br>");
                         %>
                        </div>
                        <!--Genre-->
                        <%                 
                        //Searching database
                        cursor=collection.find(new BasicDBObject("_id", session.getAttribute("_id")));                                                      

                        //Printing genre
                        try {
                            while (cursor.hasNext()) {
                                DBObject object = cursor.next();                               
                                
                                out.println("Favourite Genre : " + object.get("Genre") + "</br></br>");
                            }
                        } 
                        finally { cursor.close(); }
                        
                        
                        %>
                        
                        <!--Age-->
                        <%                 
                        //Searching database
                        cursor=collection.find(new BasicDBObject("_id", session.getAttribute("_id")));                                                      

                        //Printing age
                        try {
                            while (cursor.hasNext()) {
                                DBObject object = cursor.next();
                                out.println("Age : " + object.get("Age") + "</br></br>");
                            }
                        } 
                        finally { cursor.close(); }
                        
                        
                        %>
                        
                        <!--Platform-->
                        <%                 
                        //Searching database
                        cursor=collection.find(new BasicDBObject("_id", session.getAttribute("_id")));                                                      

                        //Printing platform
                        try {
                            while (cursor.hasNext()) {
                                DBObject object = cursor.next();
                                out.println("Platorm : " + object.get("Platform") + "</br></br>");
                            }
                        } 
                        finally { cursor.close(); }
                        
                        
                        %>
                        
                        <!--play time-->
                        <%                 
                        //Searching database
                        cursor=collection.find(new BasicDBObject("_id", session.getAttribute("_id")));                                                      

                        //Printing playhours
                        try {
                            while (cursor.hasNext()) {
                                DBObject object = cursor.next();
                                out.println("Daily Playtime : " + object.get("Play Hours") + " hours" +"</br></br>");
                            }
                        } 
                        finally { cursor.close(); }
                        
                        
                        %>
                        </div>
                        
                        <!--right panel of middle grid-->
                        <div style="background: whitesmoke; text-align: left; color: #2196F3; font-family: 'Lucida Console', Monaco, monospace; padding: 50px; padding-left: 70px; font-size: 30px">
                            <div style="text-align: center ; font-size: 40px">
                         <%
                             out.println("Friend Suggestions  <br><br>");
                         %>
                        </div>
                        
                            
                        <!-- friend suggestions-->
                            <%
                               //Searching database
                        cursor=collection.find(new BasicDBObject("_id", session.getAttribute("_id")));                                                      
                         
                        
                        String platformStr = "name";
                        try {                            
                            while (cursor.hasNext()) {
                                DBObject object = cursor.next();
                                platformStr = (String) object.get("Platform");
                                 }
                            } 
                            finally { cursor.close(); } 
                        
                            
                            
                        cursor = collection.find(new BasicDBObject("Platform",platformStr)); 
                        String addFriend = null;
                        String names = null;
                        try{
                            while(cursor.hasNext()){
                                DBObject object1 = cursor.next();
                                out.println(""  + object1.get("First Name") + " " + object1.get("Last Name") +" ---" + object1.get("GamerTag"));
                                names = (String) object1.get("GamerTag");
                                out.println("<input type = 'button' value = 'Add friend' name = 'addFriend' /><br>");
                            }
                        }
                            finally { cursor.close();}
                            %>
                        </div>
                    </div>
                        <!--bottom grid-->
                        <div id="bottom-grid" style="background: #4CAF50; text-align: left; color: black; font-family: 'Lucida Console', Monaco, monospace; padding: 50px; padding-left: 70px; font-size: 30px">
                            <div style="text-align: center ; font-size: 20px">
                         <%
                             out.println("©GameinSane<br>");
                             out.println("Advanced database Project");
                         %>
                        </div>
                        </div>
       </div>
                        <!-- Add friend-->
                        <%
                            String addfriend = request.getParameter(addFriend);
                            if(addfriend!=null){
                            BasicDBObject frienddoc = new BasicDBObject();
                            frienddoc.append("$set", new BasicDBObject().append("friends",names));
                             
                            collection.update(new BasicDBObject("_id", session.getAttribute("_id")), frienddoc);

                            }
                        %>
    </body>
</html>

<%
    
%>