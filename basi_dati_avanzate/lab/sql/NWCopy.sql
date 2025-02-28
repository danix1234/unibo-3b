CREATE TABLE NW_Categories 
( 
  CategoryID  NUMBER NOT NULL, 
  CategoryName  VARCHAR2(15) NOT NULL, 
  Description  VARCHAR2(300), 
  Picture  LONG RAW, 
CONSTRAINT PK_Categories 
  PRIMARY KEY (CategoryID)
); 


CREATE TABLE NW_Suppliers 
( 
  SupplierID  NUMBER NOT NULL, 
  CompanyName  VARCHAR2(40) NOT NULL, 
  ContactName  VARCHAR2(30), 
  ContactTitle  VARCHAR2(30), 
  Address  VARCHAR2(60), 
  City  VARCHAR2(15), 
  Region  VARCHAR2(15), 
  PostalCode  VARCHAR2(10), 
  Country  VARCHAR2(15), 
  Phone  VARCHAR2(24), 
  Fax  VARCHAR2(24), 
  HomePage  VARCHAR2(200), 
CONSTRAINT PK_Suppliers 
  PRIMARY KEY (SupplierID)
); 

CREATE TABLE NW_Products 
( 
  ProductID  NUMBER NOT NULL, 
  ProductName  VARCHAR2(40) NOT NULL, 
  SupplierID  NUMBER, 
  CategoryID  NUMBER, 
  QuantityPerUnit  VARCHAR2(20), 
  UnitPrice  NUMBER, 
  UnitsInStock  NUMBER, 
  UnitsOnOrder  NUMBER, 
  ReorderLevel  NUMBER, 
  Discontinued  NUMBER(1) NOT NULL, 
CONSTRAINT PK_Products 
  PRIMARY KEY (ProductID), 
CONSTRAINT CK_Products_UnitPrice   CHECK ((UnitPrice >= 0)), 
CONSTRAINT CK_ReorderLevel   CHECK ((ReorderLevel >= 0)), 
CONSTRAINT CK_UnitsInStock   CHECK ((UnitsInStock >= 0)), 
CONSTRAINT CK_UnitsOnOrder   CHECK ((UnitsOnOrder >= 0)), 
CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) REFERENCES NW_Categories(CategoryID), 
CONSTRAINT FK_Products_Suppliers FOREIGN KEY (SupplierID) REFERENCES NW_Suppliers(SupplierID)
); 

CREATE TABLE NW_Shippers 
( 
  ShipperID  NUMBER NOT NULL, 
  CompanyName  VARCHAR2(40) NOT NULL, 
  Phone  VARCHAR2(24), 
CONSTRAINT PK_Shippers 
  PRIMARY KEY (ShipperID)
); 


CREATE TABLE NW_Customers 
( 
  CustomerID  CHAR(5) NOT NULL, 
  CompanyName  VARCHAR2(40) NOT NULL, 
  ContactName  VARCHAR2(30), 
  ContactTitle  VARCHAR2(30), 
  Address  VARCHAR2(60), 
  City  VARCHAR2(15), 
  Region  VARCHAR2(15), 
  PostalCode  VARCHAR2(10), 
  Country  VARCHAR2(15), 
  Phone  VARCHAR2(24), 
  Fax  VARCHAR2(24), 
CONSTRAINT PK_Customers 
  PRIMARY KEY (CustomerID)
); 


CREATE TABLE NW_Employees 
( 
  EmployeeID  NUMBER NOT NULL, 
  LastName  VARCHAR2(20) NOT NULL, 
  FirstName  VARCHAR2(10) NOT NULL, 
  Title  VARCHAR2(30), 
  TitleOfCourtesy  VARCHAR2(25), 
  BirthDate  DATE, 
  HireDate  DATE, 
  Address  VARCHAR2(60), 
  City  VARCHAR2(15), 
  Region  VARCHAR2(15), 
  PostalCode  VARCHAR2(10), 
  Country  VARCHAR2(15), 
  HomePhone  VARCHAR2(24), 
  Extension  VARCHAR2(4), 
  Photo  LONG RAW, 
  Notes  VARCHAR2(600), 
  ReportsTo  NUMBER, 
  PhotoPath  VARCHAR2(255), 
CONSTRAINT PK_Employees 
  PRIMARY KEY (EmployeeID), 
CONSTRAINT FK_Employees_Employees FOREIGN KEY (ReportsTo) REFERENCES NW_Employees(EmployeeID)
) ; 

CREATE TABLE NW_Orders 
( 
  OrderID  NUMBER NOT NULL, 
  CustomerID  CHAR(5), 
  EmployeeID  NUMBER, 
  TerritoryID  VARCHAR2(20), 
  OrderDate  DATE, 
  RequiredDate  DATE, 
  ShippedDate  DATE, 
  ShipVia  NUMBER, 
  Freight  NUMBER, 
  ShipName  VARCHAR2(40), 
  ShipAddress  VARCHAR2(60), 
  ShipCity  VARCHAR2(15), 
  ShipRegion  VARCHAR2(15), 
  ShipPostalCode  VARCHAR2(10), 
  ShipCountry  VARCHAR2(15), 
CONSTRAINT PK_Orders 
  PRIMARY KEY (OrderID), 
CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES NW_Customers(CustomerID), 
CONSTRAINT FK_Orders_Employees FOREIGN KEY (EmployeeID) REFERENCES NW_Employees(EmployeeID), 
CONSTRAINT FK_Orders_Shippers FOREIGN KEY (ShipVia) REFERENCES NW_Shippers(ShipperID)
); 


CREATE TABLE NW_OrderDetails 
( 
  OrderID  NUMBER NOT NULL, 
  ProductID  NUMBER NOT NULL, 
  UnitPrice  NUMBER NOT NULL, 
  Quantity  NUMBER NOT NULL, 
  Discount  NUMBER NOT NULL, 
CONSTRAINT PK_Order_Details 
  PRIMARY KEY (OrderID, ProductID), 
CONSTRAINT CK_Discount   CHECK ((Discount >= 0 and Discount <= 1)), 
CONSTRAINT CK_Quantity   CHECK ((Quantity > 0)), 
CONSTRAINT CK_UnitPrice   CHECK ((UnitPrice >= 0)), 
CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID) REFERENCES NW_Orders(OrderID), 
CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID) REFERENCES NW_Products(ProductID)
);

--inserimenti
INSERT into NW_Categories (CategoryID, CategoryName, Description ) SELECT CategoryID, CategoryName, Description FROM NW.Categories;
INSERT into NW_Suppliers SELECT * FROM NW.Suppliers;
INSERT into NW_Products SELECT * FROM NW.Products;
INSERT into NW_Shippers SELECT * FROM NW.Shippers;
INSERT into NW_Customers SELECT * FROM NW.Customers;
INSERT into NW_Employees ( EmployeeID, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone ,  Extension , ReportsTo) SELECT EmployeeID, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone ,  Extension , ReportsTo FROM NW.Employees;
INSERT into NW_Orders SELECT * FROM NW.Orders;
INSERT into NW_OrderDetails SELECT * FROM NW.OrderDetails;


---tutto insieme (non crea i vincoli)

--create table NW1_Categories as
--select CategoryID, CategoryName, Description  from NW.Categories;
