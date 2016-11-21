1. Adding new user to specific database

  use test  
  db.createUser(  
     {  
       user: "mynewuser",  
       pwd: "myuser123",  
       roles: [ "readWrite", "dbAdmin" ]  
     }  
  );  
