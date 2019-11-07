<%@page import="com.mongodb.*" %>
<%@page import="java.util.*,java.text.SimpleDateFormat" %>
<%
String database = "gamedb";
String username = "admin";
String pass = "123456";
char[] password = pass.toCharArray();
String coll = "";

try {
 MongoClient mongoClient = new MongoClient();
 DB db = mongoClient.getDB(database);
 boolean auth = db.authenticate(username, password);

 DBCollection staff = db.getCollection("Staff");
 DBCollection access = db.getCollection("Access");

 if (request.getParameter("Submit") != null && request.getParameter("Submit").equals("Drop collections")) {
  staff.drop(); access.drop();
 }

 out.println("<h4>Collections list</h4>");
  Set<String> colls = db.getCollectionNames();
  for (String s : colls) {
  out.println(s+", ");
 }

 coll = "Access";
 out.println("<h4>" + coll + "</h4>");
 out.println("Collection '" + coll + "' count: "+ access.count() + "<br/>");

 Date date=new Date();
 String dateString = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss").format(new Date());
 out.println("Current datetime: "+dateString+"<br/>");

 DBObject lastAccess = access.findOne(); // find().limit(1) much faster

 if (lastAccess != null) {
  out.println("<h5>Updating" + coll +"</h5>");
  BasicDBObject newDoc = new BasicDBObject("_id", lastAccess.get("_id")).append("datetime", dateString);
  access.save(newDoc);
  out.println("Saved datetime (last access): "+lastAccess.get("datetime")+"<br/>");
 } else {
  out.println("<h5>Inserting " + coll + "</h5>");
  BasicDBObject doc = new BasicDBObject("datetime", dateString);
  access.insert(doc);
  lastAccess = access.findOne(); 
  out.println("Saved datetime (last access): "+lastAccess.get("datetime")+"<br/>");
 }

// using cursor
 coll = "Staff";
 out.println("<h4>" + coll + "</h4>");
 out.println("Collection '" + coll + "' count: "+ staff.count() + "<br/>");

 // prepare query 
 DBObject clause1 = new BasicDBObject("name", "John Doe");
 DBObject clause2 = new BasicDBObject("name", "John Smith");
 BasicDBList clauses = new BasicDBList();
 clauses.add(clause1); clauses.add(clause2);
 DBObject criteria = new BasicDBObject("$or", clauses);

 // if staff documents do not exist - create them
 if (! staff.find(criteria).hasNext()) {
  // insert docs
  out.println("<h5>Inserting " + coll + "</h5>");
   staff.insert(new BasicDBObject().append("name", "John Smith").append("position", "Junior Java Developer"));
  staff.insert(new BasicDBObject().append("name", "John Doe").append("position", "Senior Java Developer"));
  staff.insert(new BasicDBObject().append("name", "Bill Moe").append("position", "Manager"));
 }

 // find and print staff - ordered
 BasicDBObject sortOrder = new BasicDBObject();
 sortOrder.put("name", -1); // order DESC

 DBCursor cursor = staff.find().sort(sortOrder);
 try {
  while (cursor.hasNext()) {
  DBObject object = cursor.next();
  out.println(object.get("name") + " " + object.get("position") + "<br/>");
  }
 } finally { cursor.close(); }

 // create index
 staff.createIndex(new BasicDBObject("name", 1)); // create index on "name", ascending
 List<DBObject> list = staff.getIndexInfo();
 out.println("<h4>" + coll + " - Indexes</h4>");

 // find and print indexes
 for (DBObject o : list) { out.println(o.get("name")+", "); }

 // find Senior Java Developers
 out.println("<h4>" + coll + " - Senior Java Developers only</h4>");  

 //> db.staff.find({position:"Senior Java Developer"})
 cursor=staff.find(new BasicDBObject("position", "Senior Java Developer"));
 try {
  while (cursor.hasNext()) {
   DBObject object = cursor.next();
  out.println(object.get("name") + " " + object.get("position") + "<br/>");
  }
 } finally { cursor.close(); }

 // find Staff - updated position
 out.println("<h4>" + coll + " - position updated</h4>");  

 // update a value in doc
 BasicDBObject newDoc = new BasicDBObject();
 // this would replace whole doc instead of updating single value
 // newDoc.put("position", "Java Team Leader");
 newDoc.append("$set", new BasicDBObject().append("position", "Java Team Leader"));
 staff.update(new BasicDBObject("name", "Bill Moe"), newDoc);

 cursor = staff.find().sort(sortOrder);
 try {
   while (cursor.hasNext()) {
   DBObject object = cursor.next();
  out.println(object.get("name") + " " + object.get("position") + "<br/>");
  }
 } finally { cursor.close(); }

 // delete a doc
 out.println("<h4>" + coll + " - Staff member deleted</h4>");  
 staff.remove(new BasicDBObject().append("position","Junior Java Developer"));

 cursor = staff.find().sort(sortOrder);
 try {
  while (cursor.hasNext()) {
  DBObject object = cursor.next();
  out.println(object.get("name") + " " + object.get("position") + "<br/>");
  }
 } finally { cursor.close(); }

%><br/><form method="post">
<input type="submit" name="Submit" value="Drop collections">
<input type="button" value="Refresh" onclick="location.href=document.URL;">
</form><%
} catch(MongoException e) {
 out.println(e.getMessage());
 e.printStackTrace();
}
%>