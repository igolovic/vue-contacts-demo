USE [master]
GO
/****** Object:  Database [contacts_db]    Script Date: 29.5.2025. 18:06:27 ******/
CREATE DATABASE [contacts_db]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'contacts_db', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\contacts_db.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'contacts_db_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\contacts_db_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [contacts_db] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [contacts_db].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [contacts_db] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [contacts_db] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [contacts_db] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [contacts_db] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [contacts_db] SET ARITHABORT OFF 
GO
ALTER DATABASE [contacts_db] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [contacts_db] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [contacts_db] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [contacts_db] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [contacts_db] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [contacts_db] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [contacts_db] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [contacts_db] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [contacts_db] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [contacts_db] SET  DISABLE_BROKER 
GO
ALTER DATABASE [contacts_db] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [contacts_db] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [contacts_db] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [contacts_db] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [contacts_db] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [contacts_db] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [contacts_db] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [contacts_db] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [contacts_db] SET  MULTI_USER 
GO
ALTER DATABASE [contacts_db] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [contacts_db] SET DB_CHAINING OFF 
GO
ALTER DATABASE [contacts_db] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [contacts_db] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [contacts_db] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [contacts_db] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'contacts_db', N'ON'
GO
ALTER DATABASE [contacts_db] SET QUERY_STORE = ON
GO
ALTER DATABASE [contacts_db] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [contacts_db]
GO
/****** Object:  Table [dbo].[Contact]    Script Date: 29.5.2025. 18:06:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contact](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[LastName] [nvarchar](100) NOT NULL,
	[Email] [varchar](254) NULL,
	[Created] [datetime] NOT NULL,
	[Modified] [datetime] NULL,
 CONSTRAINT [PK_Contact] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Contact] ON 
GO
INSERT [dbo].[Contact] ([Id], [Name], [LastName], [Email], [Created], [Modified]) VALUES (2, N'Chris', N'Cornell2', NULL, CAST(N'2025-05-24T12:36:50.063' AS DateTime), CAST(N'2025-05-29T17:47:23.657' AS DateTime))
GO
INSERT [dbo].[Contact] ([Id], [Name], [LastName], [Email], [Created], [Modified]) VALUES (3, N'Layne', N'Staley', N'layne.staley@aic.com', CAST(N'2025-05-24T12:36:50.063' AS DateTime), CAST(N'2025-05-25T18:26:03.483' AS DateTime))
GO
INSERT [dbo].[Contact] ([Id], [Name], [LastName], [Email], [Created], [Modified]) VALUES (4, N'Axl', N'Rose2', N'axl.rose@gnrmail.com', CAST(N'2025-05-25T11:05:38.930' AS DateTime), CAST(N'2025-05-29T17:56:47.660' AS DateTime))
GO
INSERT [dbo].[Contact] ([Id], [Name], [LastName], [Email], [Created], [Modified]) VALUES (5, N'Freddie', N'Mercury', N'freddie.mercury@queenmail.com', CAST(N'2025-05-25T11:05:38.930' AS DateTime), NULL)
GO
INSERT [dbo].[Contact] ([Id], [Name], [LastName], [Email], [Created], [Modified]) VALUES (6, N'Bono', N'Vox', NULL, CAST(N'2025-05-25T11:05:38.930' AS DateTime), CAST(N'2025-05-25T18:09:37.480' AS DateTime))
GO
INSERT [dbo].[Contact] ([Id], [Name], [LastName], [Email], [Created], [Modified]) VALUES (7, N'Bruce', N'Dickinson', N'bruce.dickinson@ironmaidenmail.com', CAST(N'2025-05-25T11:05:38.930' AS DateTime), NULL)
GO
INSERT [dbo].[Contact] ([Id], [Name], [LastName], [Email], [Created], [Modified]) VALUES (8, N'Eddie', N'Vedder', N'eddie.vedder@pearljamail.com', CAST(N'2025-05-25T11:05:38.930' AS DateTime), NULL)
GO
INSERT [dbo].[Contact] ([Id], [Name], [LastName], [Email], [Created], [Modified]) VALUES (9, N'Sebastian', N'Bach39', N'sebastian.bach@skidrowmail.com', CAST(N'2025-05-25T11:05:38.930' AS DateTime), CAST(N'2025-05-29T17:39:20.883' AS DateTime))
GO
INSERT [dbo].[Contact] ([Id], [Name], [LastName], [Email], [Created], [Modified]) VALUES (10, N'Dave', N'Mustaine3', N'dave.mustaine@megadethmail.com', CAST(N'2025-05-25T11:05:38.930' AS DateTime), CAST(N'2025-05-25T15:06:50.463' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Contact] OFF
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteContact]    Script Date: 29.5.2025. 18:06:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_DeleteContact]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM [dbo].[Contact]
    WHERE [Id] = @Id;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllContacts]    Script Date: 29.5.2025. 18:06:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetAllContacts]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT [Id], [Name], [LastName], [Email], [Created], [Modified]
    FROM [dbo].[Contact];
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetContactById]    Script Date: 29.5.2025. 18:06:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetContactById]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT [Id], [Name], [LastName], [Email], [Created], [Modified]
    FROM [dbo].[Contact]
    WHERE [Id] = @Id;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetContactsFilteredPaged]    Script Date: 29.5.2025. 18:06:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetContactsFilteredPaged]
    @NameFilter NVARCHAR(100) = NULL,
    @LastNameFilter NVARCHAR(100) = NULL,
    @PageIndex INT,
    @PageSize INT,
    @SortColumn NVARCHAR(50) = 'LastName',
    @SortDirection NVARCHAR(4) = 'ASC'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NameFilterLike NVARCHAR(102) = NULL;
    DECLARE @LastNameFilterLike NVARCHAR(102) = NULL;

    IF (@NameFilter IS NOT NULL AND LEN(@NameFilter) > 0)
        SET @NameFilterLike = '%' + @NameFilter + '%';

    IF (@LastNameFilter IS NOT NULL AND LEN(@LastNameFilter) > 0)
        SET @LastNameFilterLike = '%' + @LastNameFilter + '%';

    SELECT COUNT(*) AS TotalCount
    INTO #TotalCount
    FROM [dbo].[Contact]
    WHERE (@NameFilterLike IS NULL OR [Name] LIKE @NameFilterLike)
      AND (@LastNameFilterLike IS NULL OR [LastName] LIKE @LastNameFilterLike);

    SELECT
        Id,
        Name,
        LastName,
        Email,
        Created,
        Modified
    FROM (
        SELECT
            ROW_NUMBER() OVER (
                ORDER BY
                    CASE WHEN @SortColumn = 'Name' AND @SortDirection = 'ASC' THEN Name END ASC,
                    CASE WHEN @SortColumn = 'Name' AND @SortDirection = 'DESC' THEN Name END DESC,
                    CASE WHEN @SortColumn = 'LastName' AND @SortDirection = 'ASC' THEN LastName END ASC,
                    CASE WHEN @SortColumn = 'LastName' AND @SortDirection = 'DESC' THEN LastName END DESC,
                    CASE WHEN @SortColumn = 'Email' AND @SortDirection = 'ASC' THEN Email END ASC,
                    CASE WHEN @SortColumn = 'Email' AND @SortDirection = 'DESC' THEN Email END DESC,
					CASE WHEN @SortColumn = 'Created' AND @SortDirection = 'ASC' THEN Created END ASC,
					CASE WHEN @SortColumn = 'Created' AND @SortDirection = 'DESC' THEN Created END DESC,
					CASE WHEN @SortColumn = 'Modified' AND @SortDirection = 'ASC' THEN Modified END ASC,
					CASE WHEN @SortColumn = 'Modified' AND @SortDirection = 'DESC' THEN Modified END DESC
            ) AS RowNum,
            Id,
            Name,
            LastName,
            Email,
            Created,
            Modified
        FROM [dbo].[Contact]
        WHERE (@NameFilterLike IS NULL OR [Name] LIKE @NameFilterLike)
          AND (@LastNameFilterLike IS NULL OR [LastName] LIKE @LastNameFilterLike)
    ) AS RowConstrainedResult
    WHERE RowNum > @PageIndex * @PageSize
      AND RowNum <= (@PageIndex + 1) * @PageSize
    ORDER BY RowNum;

    SELECT TotalCount FROM #TotalCount;
    DROP TABLE #TotalCount;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_InsertContact]    Script Date: 29.5.2025. 18:06:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsertContact]
    @Name NVARCHAR(100),
    @LastName NVARCHAR(100),
    @Email VARCHAR(254)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [dbo].[Contact] ([Name], [LastName], [Email], [Created])
    VALUES (@Name, @LastName, @Email, GETDATE());

    SELECT SCOPE_IDENTITY() AS NewContactId;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateContact]    Script Date: 29.5.2025. 18:06:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_UpdateContact]
    @Id INT,
    @Name NVARCHAR(100),
    @LastName NVARCHAR(100),
    @Email VARCHAR(254)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [dbo].[Contact]
    SET [Name] = @Name,
        [LastName] = @LastName,
        [Email] = @Email,
        [Modified] = GETDATE()
    WHERE [Id] = @Id;
END
GO
USE [master]
GO
ALTER DATABASE [contacts_db] SET  READ_WRITE 
GO
