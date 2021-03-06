USE [FleetDB]
GO
/****** Object:  Table [dbo].[BackupOrdersPort]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BackupOrdersPort](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ShiftId] [int] NULL,
	[OrderId] [int] NULL,
	[TableId] [int] NULL,
	[TableNumber] [int] NULL,
	[Item] [nvarchar](250) NULL,
	[ItemQuantity] [int] NULL,
	[Port] [int] NULL,
	[Submit] [bit] NULL,
	[SubmitTime] [datetime] NULL,
	[Working] [datetime] NULL,
	[Done] [datetime] NULL,
	[Waiter] [nvarchar](250) NULL,
	[DoneShow] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BackupTables]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BackupTables](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ShiftId] [int] NULL,
	[TableId] [int] NULL,
	[Number] [int] NULL,
	[Subtotal] [float] NULL,
	[Tax] [int] NULL,
	[Subtax] [float] NULL,
	[Discount] [int] NULL,
	[Subdiscount] [float] NULL,
	[Total] [float] NULL,
	[CreatedBy] [nvarchar](250) NULL,
	[CreatedDate] [datetime] NULL,
	[Cashed] [bit] NULL,
	[ClosedDate] [datetime] NULL,
	[ReceiptNo] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BackupTablesOrders]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BackupTablesOrders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ShiftId] [int] NULL,
	[OrderId] [int] NULL,
	[TableNumber] [int] NULL,
	[TableId] [int] NULL,
	[Item] [nvarchar](250) NULL,
	[ItemQuantity] [int] NULL,
	[ItemTotal] [float] NULL,
	[Port] [int] NULL,
	[Pickup] [datetime] NULL,
	[Submit] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ButcherStore]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ButcherStore](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[inQuantity] [float] NOT NULL,
	[outQuantity] [float] NOT NULL,
	[Price] [float] NOT NULL,
	[Date] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ButcherStoreOut]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ButcherStoreOut](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[outRequest] [float] NOT NULL,
	[butcherID] [int] NOT NULL,
	[requestID] [int] NOT NULL,
	[Date] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Card]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Card](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[GroupId] [int] NULL,
	[Barcode] [float] NULL,
	[Name] [nvarchar](250) NULL,
	[Type] [nvarchar](250) NULL,
	[Subtype] [nvarchar](250) NULL,
	[QuantityWarning] [float] NULL,
	[QuantityEmpty] [float] NULL,
	[LastPrice] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CardGroup]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CardGroup](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CardType]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CardType](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](250) NULL,
	[Subtype] [nvarchar](250) NULL,
	[QunTypeToSubtype] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CashierShift]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CashierShift](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NULL,
	[Subtotal] [float] NULL,
	[Subtax] [float] NULL,
	[Subdiscount] [float] NULL,
	[total] [float] NULL,
	[SubtotalAll] [float] NULL,
	[SubtaxAll] [float] NULL,
	[SubdiscountAll] [float] NULL,
	[InternetTotal] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DailyInternet]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DailyInternet](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Value] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DailyTables]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DailyTables](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Number] [int] NULL,
	[Subtotal] [float] NULL,
	[Tax] [int] NULL,
	[Subtax] [float] NULL,
	[Discount] [int] NULL,
	[Subdiscount] [float] NULL,
	[Total] [float] NULL,
	[CreatedBy] [nvarchar](250) NULL,
	[CreatedDate] [datetime] NULL,
	[Cashed] [bit] NULL,
	[ClosedDate] [datetime] NULL,
	[ReceiptNo] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DailyTablesOrders]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DailyTablesOrders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TableNumber] [int] NULL,
	[TableId] [int] NULL,
	[Item] [nvarchar](250) NULL,
	[ItemQuantity] [int] NULL,
	[ItemTotal] [float] NULL,
	[Port] [int] NULL,
	[Pickup] [datetime] NULL,
	[Submit] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ErrorDebug]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErrorDebug](
	[ErrorID] [int] IDENTITY(1,1) NOT NULL,
	[Message] [nvarchar](250) NULL,
	[Type] [nvarchar](250) NULL,
	[Variables] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventActivities]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventActivities](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Activity] [text] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventMeals]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventMeals](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Meal] [text] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Events]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Events](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Event] [text] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FalandaraClients]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FalandaraClients](
	[ClientID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[PhoneNumber] [varchar](50) NOT NULL,
	[Email] [nvarchar](250) NULL,
	[History] [int] NOT NULL,
	[Rank] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FalandaraTableOrders]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FalandaraTableOrders](
	[OrderID] [bigint] IDENTITY(1,1) NOT NULL,
	[TableID] [bigint] NOT NULL,
	[Persons] [int] NOT NULL,
	[MealID] [int] NOT NULL,
	[Comment] [nvarchar](250) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FalandaraTables]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FalandaraTables](
	[TableID] [bigint] IDENTITY(1,1) NOT NULL,
	[TripID] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[Deck] [int] NOT NULL,
	[Persons] [int] NOT NULL,
	[TotalPrice] [float] NOT NULL,
	[Deposit] [float] NOT NULL,
	[ClientID] [bigint] NOT NULL,
	[DiscountPrcnt] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FalandaraTrips]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FalandaraTrips](
	[TripID] [int] IDENTITY(1,1) NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[Submit] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InitialPortStock]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InitialPortStock](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PortId] [int] NULL,
	[CardId] [int] NULL,
	[Qun] [float] NULL,
	[Price] [float] NULL,
	[Total] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InitialStockDate]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InitialStockDate](
	[Date] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InitialStoreStock]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InitialStoreStock](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CardId] [int] NULL,
	[Qun] [float] NULL,
	[Price] [float] NULL,
	[Total] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Menu]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Menu](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NULL,
	[Price] [float] NULL,
	[GroupId] [int] NULL,
	[Ports] [int] NULL,
	[IndirectCost] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenuGroup]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuGroup](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NULL,
	[Show] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenuTable]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuTable](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ItemName] [nvarchar](250) NULL,
	[ItemPrice] [float] NULL,
	[ItemDescription] [nvarchar](500) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OfficerTables]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OfficerTables](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OfficerNum] [int] NULL,
	[Shift] [int] NULL,
	[Date] [datetime] NULL,
	[Hospitality] [bit] NULL,
	[Qun] [float] NULL,
	[ItemID] [int] NULL,
	[Total] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdersPort]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdersPort](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TableId] [int] NULL,
	[TableNumber] [int] NULL,
	[Item] [nvarchar](250) NULL,
	[ItemQuantity] [int] NULL,
	[Port] [int] NULL,
	[Submit] [bit] NULL,
	[SubmitTime] [datetime] NULL,
	[Working] [datetime] NULL,
	[Done] [datetime] NULL,
	[Waiter] [nvarchar](250) NULL,
	[DoneShow] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Port]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Port](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PortsStore]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PortsStore](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[CardID] [int] NULL,
	[Stock] [float] NULL,
	[PortID] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RamadanClients]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RamadanClients](
	[ClientID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[PhoneNumber] [varchar](50) NOT NULL,
	[Email] [nvarchar](250) NULL,
	[History] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RamadanMeals]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RamadanMeals](
	[MealID] [int] IDENTITY(1,1) NOT NULL,
	[Meal] [nvarchar](250) NOT NULL,
	[Price] [float] NOT NULL,
	[Type] [nvarchar](250) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RamadanTableOrders]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RamadanTableOrders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[TableID] [int] NOT NULL,
	[Persons] [int] NOT NULL,
	[MealID] [int] NOT NULL,
	[Comment] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RamadanTables]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RamadanTables](
	[TableID] [int] IDENTITY(1,1) NOT NULL,
	[TableNumber] [int] NOT NULL,
	[Type] [nvarchar](250) NOT NULL,
	[Venue] [nvarchar](250) NOT NULL,
	[RamadanDay] [int] NOT NULL,
	[Date] [date] NULL,
	[Persons] [int] NOT NULL,
	[TotalPrice] [float] NOT NULL,
	[Deposit] [float] NULL,
	[ClientID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RamadanVenues]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RamadanVenues](
	[VenueID] [int] IDENTITY(1,1) NOT NULL,
	[Venue] [nvarchar](250) NOT NULL,
	[Limit] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Recipe]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Recipe](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[CardID] [int] NULL,
	[ItemID] [int] NULL,
	[Quantity] [float] NULL,
	[PortID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Store]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Store](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[CardID] [int] NULL,
	[Stock] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StoreAddRequest]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoreAddRequest](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NULL,
	[Printed] [bit] NULL,
	[UserName] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StoreAddRequestDetails]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoreAddRequestDetails](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[AddID] [int] NULL,
	[CardID] [int] NULL,
	[Cost] [float] NULL,
	[Quantity] [float] NULL,
	[Total] [float] NULL,
	[Notes] [nvarchar](500) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StoreDisposeRequest]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoreDisposeRequest](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NULL,
	[Printed] [bit] NULL,
	[Reason] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StoreDisposeRequestDetails]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoreDisposeRequestDetails](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DisposeID] [int] NULL,
	[CardID] [int] NULL,
	[Quantity] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StoreOutRequest]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoreOutRequest](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NULL,
	[PortID] [int] NOT NULL,
	[Printed] [bit] NULL,
	[UserName] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StoreOutRequestDetails]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoreOutRequestDetails](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[OutID] [int] NULL,
	[CardID] [int] NULL,
	[Quantity] [float] NULL,
	[Note] [nvarchar](500) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NULL,
	[Password] [varbinary](200) NULL,
	[UserType] [nvarchar](250) NULL,
	[Active] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Venues]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Venues](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Venue] [text] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VoidItems]    Script Date: 12/4/2021 7:18:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VoidItems](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Item] [nvarchar](250) NOT NULL,
	[Date] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ButcherStore] ADD  CONSTRAINT [DF_ButcherStore_outQuantity]  DEFAULT ((0)) FOR [outQuantity]
GO
ALTER TABLE [dbo].[DailyTablesOrders] ADD  CONSTRAINT [DF_DailyTablesOrders_Submit]  DEFAULT ((0)) FOR [Submit]
GO
ALTER TABLE [dbo].[FalandaraClients] ADD  CONSTRAINT [DF_FalandaraClients_History]  DEFAULT ((1)) FOR [History]
GO
ALTER TABLE [dbo].[FalandaraTableOrders] ADD  CONSTRAINT [DF_FalandaraTableOrders_Comment]  DEFAULT (N'.') FOR [Comment]
GO
ALTER TABLE [dbo].[FalandaraTables] ADD  CONSTRAINT [DF_FalandaraTables_Deposit]  DEFAULT ((0)) FOR [Deposit]
GO
ALTER TABLE [dbo].[FalandaraTables] ADD  CONSTRAINT [DF_FalandaraTables_DiscountPrcnt]  DEFAULT ((0)) FOR [DiscountPrcnt]
GO
ALTER TABLE [dbo].[FalandaraTrips] ADD  CONSTRAINT [DF_FalandaraTrips_Submit]  DEFAULT ((0)) FOR [Submit]
GO
ALTER TABLE [dbo].[OrdersPort] ADD  CONSTRAINT [DF_OrdersPort_Submit]  DEFAULT ((0)) FOR [Submit]
GO
ALTER TABLE [dbo].[RamadanClients] ADD  CONSTRAINT [DF_RamadanClients_History]  DEFAULT ((1)) FOR [History]
GO
