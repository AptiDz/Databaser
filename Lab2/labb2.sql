-- Tabeller

-- Skapelser

-- Databas

CREATE DATABASE bookhandel_Apti_Umit;

-- Författare
CREATE TABLE
  Writer (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    [Name] NVARCHAR(20) NOT NULL,
    Lastname NVARCHAR(20) NOT NULL,
    [Date of birth] DATE NOT NULL);

-- Förlag 
CREATE TABLE 
  Publisher (
    PublisherID INT IDENTITY(1,1) PRIMARY KEY,
    [Name] NVARCHAR(50) NOT NULL,
    [Address] NVARCHAR(50) NULL);

-- Kategori 
CREATE TABLE 
  Category (
  CategoryID INT IDENTITY(1,1) PRIMARY KEY,
  [Name] NVARCHAR(50) NOT NULL,
  [Description] NVARCHAR(255) NULL);

-- Böcker
CREATE TABLE 
  Book (
    ISBN13 CHAR(13) PRIMARY KEY,
    Title NVARCHAR(50) NOT NULL,
    [Language] NVARCHAR(10) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    [Release Date] DATE NOT NULL,
    WriterID INT NOT NULL,
    PublisherID INT NULL,
    CategoryID INT NULL,
    CONSTRAINT CK_Book_ISBN13_len CHECK (LEN(ISBN13) = 13),
    CONSTRAINT FK_Book_Writer FOREIGN KEY (WriterID)
      REFERENCES Writer(ID),
    CONSTRAINT FK_Book_Publisher FOREIGN KEY (PublisherID)
      REFERENCES Publisher(PublisherID),
    CONSTRAINT FK_Book_Category FOREIGN KEY (CategoryID)
      REFERENCES Category(CategoryID));

-- Butiker
CREATE TABLE 
  Store (
    StoreID INT IDENTITY(1,1) PRIMARY KEY,
    [Name] NVARCHAR(50) NOT NULL,
    [Address] NVARCHAR(50) NOT NULL);

-- Lagersaldo
CREATE TABLE 
  Inventory (
    StoreID INT NOT NULL,
    ISBN13 CHAR(13) NOT NULL,
    [Number of items] INT NOT NULL CHECK ([Number of items] >= 0),
    PRIMARY KEY (StoreID, ISBN13),
    CONSTRAINT FK_Inventory_Store FOREIGN KEY (StoreID)
      REFERENCES Store(StoreID),
    CONSTRAINT FK_Inventory_Book FOREIGN KEY (ISBN13)
      REFERENCES Book(ISBN13));

-- Demodata

-- Insättning

-- Författare

INSERT
INTO
  Writer ([Name], Lastname, [Date of birth])
VALUES
  ('Astrid', 'Lindgren', '1907-11-14'),
  ('Martin', 'Widmark', '1961-03-19'),
  ('Camilla', 'Läckberg', '1974-08-30'),
  ('Lars', 'Kepler', '1967-01-20');

-- Förlag

INSERT 
INTO 
  Publisher ([Name], [Address])
VALUES
  ('Rabén & Sjögren', 'Tryckerigatan 4, 111 28 Stockholm'),
  ('Norstedts förlag', 'Tryckerigatan 4, 111 28 Stockholm'),
  ('Bonnier Carlsen', 'Sveavägen 56, 111 34 Stockholm'),
  ('Bokförlaget Forum', 'Sveavägen 56, 111 34 Stockholm'),
  ('HarperCollins Nordic', 'Industrigatan 4A, 112 46 Stockholm'),
  ('Albert Bonniers Förlag', 'Sveavägen 56, 111 34 Stockholm');

-- Kategori

INSERT
INTO
  Category ([Name], [Description])
VALUES
  ('Barn', 'Barn- och ungdomslitteratur'),  
  ('Klassiker', 'Svenska och utländska klassiker som stått sig över tid'),
  ('Deckare', 'Kriminalromaner och thrillers'),
  ('Roman', 'Skönlitterära berättelser om livet, kärlek, relationer'),
  ('Skräck', 'Berättelser som syftar till att skapa spänning eller rädsla');

-- Böcker

INSERT
INTO
  Book (ISBN13, Title, [Language], Price, [Release Date], WriterID, PublisherID, CategoryID)
VALUES
  ('9789129723632', 'Pippi Långstrump', 'sv', 129.00, '1945-11-01', 1, 1, 1),
  ('9789129443226', 'Emil i Lönneberga', 'sv', 119.00, '1963-01-01', 1, 1, 1),
  ('9789163854019', 'Nelly Rapp: Monsterakademin & Frankensteinaren', 'sv', 99.00, '2003-01-01', 2, 2, 1),
  ('9789163847790', 'Diamantmysteriet (LasseMajas detektivbyrå #1)', 'sv', 89.00, '2002-01-01', 2, 2, 1),
  ('9789170013928', 'Isprinsessan', 'sv', 89.00, '2003-01-01', 3, 4, 3),
  ('9789170012631', 'Predikanten', 'sv', 89.00, '2004-01-01', 3, 4, 3),
  ('9789170017582', 'Hypnotisören', 'sv', 99.00, '2009-01-01', 4, 6, 3),
  ('9789100124694', 'Paganinikontraktet', 'sv', 99.00, '2010-01-01', 4, 6, 3);

-- Butiker

INSERT
INTO
  Store ([Name], [Address])
VALUES
  ('Akademibokhandeln Stockholm', 'Regeringsgatan 56, 111 56 Stockholm'),
  ('Akademibokhandeln Göteborg', 'Kungsgatan 45, 411 17 Göteborg'),
  ('Akademibokhandeln Malmö', 'Södra Förstadsgatan 12, 211 43 Malmö');

-- Lagersaldo

INSERT
INTO
  Inventory (StoreID, ISBN13, [Number of items])
VALUES
  (1, '9789129723632', 12), 
  (1, '9789129443226', 10),
  (1, '9789163847790',  8), 
  (1, '9789163854019',  9),
  (1, '9789170013928',  7),
  (1, '9789170012631',  6),
  (1, '9789170017582',  5), 
  (1, '9789100124694',  4),
  (2, '9789129723632',  7),
  (2, '9789129443226',  5),
  (2, '9789163847790',  6),
  (2, '9789163854019',  4),
  (2, '9789170013928',  3),
  (2, '9789170012631',  2),
  (2, '9789170017582',  3),
  (2, '9789100124694',  1),
  (3, '9789129723632',  9),
  (3, '9789129443226',  7),
  (3, '9789163847790',  5),
  (3, '9789163854019',  6),
  (3, '9789170013928',  4),
  (3, '9789170012631',  3),
  (3, '9789170017582',  2),
  (3, '9789100124694',  2);

-- VY View

CREATE VIEW 
  TitlesPerWriter AS
SELECT 
  f.Name + ' ' + f.Lastname AS [Name],
  DATEDIFF(YEAR, f.[Date of birth], GETDATE()) AS Age,
  COUNT(DISTINCT b.ISBN13)           AS Titles,
  ISNULL(SUM(b.Price * ls.[Number of items]),0)   AS Inventory
FROM Writer AS f
LEFT JOIN Book AS b  ON b.WriterID = f.ID
LEFT JOIN Inventory AS ls ON ls.ISBN13 = b.ISBN13
GROUP BY f.Name, f.Lastname, f.[Date of birth];


SELECT * from TitlesPerWriter