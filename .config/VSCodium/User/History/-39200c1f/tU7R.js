const user = process.env.MONGO_INITDB_ROOT_USERNAME;
const password = process.env.MONGO_INITDB_ROOT_PASSWORD;

db.getSiblingDB("admin").createUser(
    {
        user: user,
        pwd:  password,
        roles:[
            {
                role: "readWrite",
                db:  "admin"
            }
        ]
    }
);
