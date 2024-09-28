def create_keyspace(session, keyspace): 
   """
   Create a Keyspace in Cassandra.
   """
   keyspace_query = f"""
      CREATE KEYSPACE IF NOT EXISTS {keyspace}
      WITH replication = {{'class': 'SimpleStrategy', 'replication_factor': 1}};
   """
   
   session.execute(keyspace_query)
   print(f"Keyspace '{keyspace}' created in session ...")

def set_keyspace(session, keyspace):
   """
   Set the active Keyspace for the session.
   """
   session.set_keyspace(keyspace)
   print(f"Keyspace '{keyspace}' used in session ...")

def create_jobs(session):
   """
   Create a table in the active Keyspace.
   """
   create_table_query = f"""
      CREATE TABLE IF NOT EXISTS jobs (
         id TEXT PRIMARY KEY,
         intitule TEXT,
         dateCreation timestamp,
         commune TEXT,
         entreprise TEXT,
         secteurActivite TEXT,
         metier TEXT,
         typeContrat TEXT,
         natureContrat TEXT,
         experienceExige TEXT
      );
   """
   session.execute(create_table_query)
   print("\033[1m\033[92mTable jobs created ...\033[0m")

def create_communes(session, communes):
   session.execute("""
      CREATE TABLE IF NOT EXISTS communes (
         code TEXT PRIMARY KEY,
         libelle TEXT
      );
   """)
   session.execute("""
      CREATE TABLE IF NOT EXISTS jobs_communes (
         code TEXT PRIMARY KEY,
         count COUNTER
      );
   """)
   insert_query = "INSERT INTO communes (code, libelle) VALUES (%s, %s)"
   for commune in communes:
      session.execute(insert_query, (commune['code'], commune['libelle']))
   print("\033[1m\033[92mCommunes tables created ...\033[0m")

def create_departements(session, departements):
   session.execute("""
      CREATE TABLE IF NOT EXISTS departements (
         code TEXT PRIMARY KEY,
         libelle TEXT
      );
   """)
   session.execute("""
      CREATE TABLE IF NOT EXISTS jobs_departements (
         code TEXT PRIMARY KEY,
         count COUNTER
      );
   """)
   insert_query = "INSERT INTO departements (code, libelle) VALUES (%s, %s)"
   for departement in departements:
      session.execute(insert_query, (departement['code'], departement['libelle']))
   print("\033[1m\033[92mDepartements tables created ...\033[0m")

def increment_counter(session, codeCommune):
   increment_commune = """
      UPDATE jobs_communes
      SET count = count + 1
      WHERE code = %s;
   """
   increment_departement = """
      UPDATE jobs_departements
      SET count = count + 1
      WHERE code = %s
   """
   session.execute(increment_departement, (codeCommune[:2],))
   session.execute(increment_commune, (codeCommune,))

   print("\033[1m\033[92mCommunes and departements count updated....\033[0m")

def insert_data(session, job):
   """
   Insert data into a table.
   """
   insert_query = """
      INSERT INTO jobs (id, intitule, dateCreation, commune, entreprise, secteurActivite, metier, typeContrat, natureContrat, experienceExige) 
      VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
   """
   session.execute(insert_query, (
      job["id"],
      job.get("intitule", None),
      job.get("dateCreation", None),
      job.get("lieuTravail", {}).get("commune", None),
      job.get("entreprise", {}).get("nom", None),
      job.get("secteurActivite", None),
      job.get("romeCode", None),
      job.get("typeContrat", None),
      job.get("natureContrat", None),
      job.get("experienceExige", None)
   ))
   print("\033[1m\033[92m1 row added successfully to jobs ....\033[0m")
