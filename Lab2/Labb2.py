# Importering av nödvändiga moduler
from sqlalchemy import create_engine, MetaData, Table, select, bindparam
from sqlalchemy.orm import sessionmaker
import urllib.parse

def main():
 
    # Skapelse av connection string för Windows Authentication
    server = 'localhost'
    database = 'bookhandel_Apti_Umit'
    driver = 'ODBC Driver 17 for SQL Server'
    
    connection_string = (
        f"mssql+pyodbc://@{server}/{database}"
        f"?driver={urllib.parse.quote_plus(driver)}"
        "&trusted_connection=yes")
    
    # Skapelse av engine och session
    engine = create_engine(connection_string, echo=False) # echo false ser till att inga SGL-satser loggas med känsliga parametrar
    Session = sessionmaker(bind=engine)
    session_starter = Session()
    
    # Laddar metadata och tabeller från databasen 
    metadata = MetaData()

    # Reflektering av endast tabeller som ska används    
    Book = Table('Book', metadata, autoload_with=engine)
    Store = Table('Store', metadata, autoload_with=engine)
    Inventory = Table('Inventory', metadata, autoload_with=engine)
    
    # Byggning av parametriserad och säker select-fråga
    stmt = (
        select(
            Book.c.Title.label("Title"),
            Store.c.Name.label("Store"),
            Inventory.c["Number of items"].label("Number of items"))
        .select_from(
            Book.join(Inventory, Book.c.ISBN13 == Inventory.c.ISBN13)
                .join(Store, Inventory.c.StoreID == Store.c.StoreID))
        .where(Book.c.Title.ilike(bindparam("p_title"))))
    
    # Hämtar söksträng från användarens input
    raw_search = input("Ange title på boken eller del av title att söka efter: ").strip()
    if not raw_search:
        print("Ingen sökterm angiven, avslutar.")
        return
    
    # Förberedning av parametern med wildcard
    pattern = f"%{raw_search}%"
    
    # Körning av fråga och hämta resultatet
    result = session_starter.execute(stmt, {"p_title": pattern}).fetchall() # Tack vara bindparam(p_title) så skickas det som en parameter till databasmotorn – den byggs alltså inte ihop som en sträng och kan därför inte utnyttjas för injektion.
    
    # Resultat av sökning
    if result:
        print("\n\tResultat av sökningen:")
        for title, store_name, num_items in result:
            print(f"Book: {title}, Store: {store_name}, Inventory: {num_items}")
    else:
        print("\nTyvärr inga matchningar hittades.")
        
    # Stänga sessionen och script
    session_starter.close()

if __name__ == "__main__":

    main()

# Script från Apti Dzhamurzaev & Umit Ekici