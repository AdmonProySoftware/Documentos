USE [master]
GO
/****** Object:  Database [QuickList]    Script Date: 4/22/2020 6:43:18 PM ******/
CREATE DATABASE [QuickList]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QuickList', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\QuickList.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'QuickList_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\QuickList_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [QuickList] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QuickList].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QuickList] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QuickList] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QuickList] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QuickList] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QuickList] SET ARITHABORT OFF 
GO
ALTER DATABASE [QuickList] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [QuickList] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QuickList] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QuickList] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QuickList] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QuickList] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QuickList] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QuickList] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QuickList] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QuickList] SET  DISABLE_BROKER 
GO
ALTER DATABASE [QuickList] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QuickList] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QuickList] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QuickList] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QuickList] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QuickList] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QuickList] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QuickList] SET RECOVERY FULL 
GO
ALTER DATABASE [QuickList] SET  MULTI_USER 
GO
ALTER DATABASE [QuickList] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QuickList] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QuickList] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QuickList] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [QuickList] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'QuickList', N'ON'
GO
ALTER DATABASE [QuickList] SET QUERY_STORE = OFF
GO
USE [QuickList]
GO
/****** Object:  User [QuickListUser]    Script Date: 4/22/2020 6:43:18 PM ******/
CREATE USER [QuickListUser] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [quicklistu]    Script Date: 4/22/2020 6:43:18 PM ******/
CREATE USER [quicklistu] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [QuickListUser]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [QuickListUser]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [QuickListUser]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [QuickListUser]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [QuickListUser]
GO
ALTER ROLE [db_datareader] ADD MEMBER [QuickListUser]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [QuickListUser]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [QuickListUser]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [QuickListUser]
GO
/****** Object:  UserDefinedFunction [dbo].[fnCustomPass]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnCustomPass] 
(    
    @size AS INT, --Tamaño de la cadena aleatoria
    @op AS VARCHAR(2) --Opción para letras(ABC..), numeros(123...) o ambos.
)
RETURNS VARCHAR(62)
AS
BEGIN    

    DECLARE @chars AS VARCHAR(52),
            @numbers AS VARCHAR(10),
            @strChars AS VARCHAR(62),        
            @strPass AS VARCHAR(62),
            @index AS INT,
            @cont AS INT

    SET @strPass = ''
    SET @strChars = ''    
    SET @chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    SET @numbers = '0123456789'

    SET @strChars = CASE @op WHEN 'C' THEN @chars --Letras
                        WHEN 'N' THEN @numbers --Números
                        WHEN 'CN' THEN @chars + @numbers --Ambos (Letras y Números)
                        ELSE '------'
                    END

    SET @cont = 0
    WHILE @cont < @size
    BEGIN
        SET @index = ceiling( ( SELECT rnd FROM vwRandom ) * (len(@strChars)))--Uso de la vista para el Rand() y no generar error.
        SET @strPass = @strPass + substring(@strChars, @index, 1)
        SET @cont = @cont + 1
    END    
        
    RETURN @strPass

END
GO
/****** Object:  View [dbo].[vwRandom]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwRandom]
AS
SELECT RAND() as Rnd
GO
/****** Object:  Table [dbo].[alumnos]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[alumnos](
	[id_alumnos] [int] NOT NULL,
	[matricula] [varchar](10) NULL,
	[apellidos] [varchar](50) NULL,
	[nombres] [varchar](50) NULL,
	[tipo_usuario] [int] NULL,
	[password] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_alumnos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[alumnos_materias]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[alumnos_materias](
	[alumnos_materias] [int] NOT NULL,
	[id_alumnos] [int] NULL,
	[id_materias] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[alumnos_materias] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bitacora_asistencias]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bitacora_asistencias](
	[id_alumno] [int] NULL,
	[id_materia] [int] NULL,
	[fecha_asistencia] [date] NULL,
	[asistencia] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[clave]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clave](
	[clave] [varchar](50) NULL,
	[activo] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[maestros]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[maestros](
	[id_maestros] [int] NOT NULL,
	[apellidos] [varchar](50) NULL,
	[nombres] [varchar](50) NULL,
	[tipo_usuario] [int] NULL,
	[password] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_maestros] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[materias]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[materias](
	[id_materias] [int] NOT NULL,
	[materia] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_materias] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tipo_usuarios]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tipo_usuarios](
	[tipo_usuario] [int] NOT NULL,
	[descripcion] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[tipo_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usuarios]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuarios](
	[id_usuario] [int] NOT NULL,
	[matricula] [varchar](10) NULL,
	[apellidos] [varchar](50) NULL,
	[nombres] [varchar](50) NULL,
	[tipo_usuario] [int] NULL,
	[password] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (1, N'1745920', N'Alvarez Ruiz', N'Saul Osvaldo', 2, N'S9L4RVUBRH')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (2, N'1796895', N'Cavazos Guzman', N'Oziel Alejandro', 2, N'I5EWGBZOOW')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (3, N'1803993', N'Contreras Torres', N'Reynaldo', 2, N'AETAKSK9OB')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (4, N'1675786', N'De La Fuente Aguayo', N'Mauricio Javier', 2, N'ZV338ZXEZQ')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (5, N'1793929', N'De La Rosa Medina', N'Milton Javier', 2, N'SLTVDOCIZ1')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (6, N'1799114', N'Dominguez Azueta', N'Nidia Estefania', 2, N'SL3EI1WI0I')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (7, N'1748613', N'Esparza Ramos', N'Kenneth Sajid', 2, N'0XQFXSHY50')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (8, N'1755663', N'Fuentes Marquez', N'Javier Romario', 2, N'MDZKL9UBAK')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (9, N'1889467', N'Garcia Ballesteros', N'Miguel Angel', 2, N'PXF38W92TC')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (10, N'1813150', N'Garcia Roque', N'Miguel Angel', 2, N'FW91X6V5KO')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (11, N'1488273', N'onzalez Salazar', N'Jorge Luis', 2, N'V0ZJB65CTB')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (12, N'1677529', N'Guerrero Reyes', N'Angel Missael', 2, N'GIYB4EANWL')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (13, N'1807983', N'Gutierrez Rodriguez', N'Fausto Martin', 2, N'I4WIIDHGEV')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (14, N'1753891', N'Hernandez Alonso', N'Cecilia Lizbeth', 2, N'IC54ZUN2CM')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (15, N'1810972', N'Ibarra Barrientos', N'Edgar Alejandro', 2, N'FA16A78JVG')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (16, N'1798180', N'Juarez Vega', N'Axel Rosario', 2, N'4GDJYUACW7')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (17, N'1669378', N'Llanas Perez', N'Hector Jesus', 2, N'7UGSJLJMUN')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (18, N'1751483', N'Lopez Gomez', N'Humberto Salvador', 2, N'FGB4OHUO7A')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (19, N'1746638', N'Lozano Lomas', N'Sharon Berenice', 2, N'MSWNIJ75P9')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (20, N'1685707', N'Macias Cabrales', N'Alejandra Carolina', 2, N'EJGEGIHWCX')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (21, N'1810911', N'Martinez Flores', N'Jorge Adrian', 2, N'ZSFGCAMQZM')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (22, N'1681075', N'Perez Gallardo', N'Moises Alejandro', 2, N'LKLJ32QDS7')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (23, N'1739955', N'Picazzo Casillas', N'Ricardo Arturo', 2, N'GTHIB6CC4G')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (24, N'1662083', N'Rebolloso Garcia', N'Enrique Alejandro', 2, N'A36CKIV6IU')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (25, N'1738673', N'Rodriguez Palacios', N'Jose Guadalupe', 2, N'2AI2Q2DNDU')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (26, N'1733781', N'Sanchez Garcia', N'Jose Ignacio', 2, N'V1X01OSY5O')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (27, N'1736733', N'Silva Beltrán', N'Felix Adan', 2, N'6FH5J3DW7E')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (28, N'1724180', N'Silva Garza', N'Oziel Alejandro', 2, N'XSPJSCX79N')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (29, N'1768129', N'Soto Cansino', N'Juan Jose', 2, N'7KY78OYZKG')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (30, N'1873930', N'Treviño Paez', N'Gustavo', 2, N'TLIOTSUOPN')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (31, N'1794331', N'Vega Aleman', N'Jose Gabriel Tadeo', 2, N'1W7VR7S981')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (32, N'1676372', N'Velez Quintanar', N'Nestor Oziel', 2, N'6V0ETTP8AK')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (33, N'1810492', N'Vitela Rodriguez', N'Vania Janeli', 2, N'4DYAUFE8LU')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (34, N'1741500', N'Zapata Santiago', N'Jorge Antonio', 2, N'V0RHLKLQXV')
INSERT [dbo].[alumnos] ([id_alumnos], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (99, N'1', N'demo', N'demo', 3, N'123456')
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (1, 1, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (2, 2, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (3, 3, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (4, 4, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (5, 5, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (6, 6, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (7, 7, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (8, 8, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (9, 9, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (10, 10, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (11, 11, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (12, 12, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (13, 13, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (14, 14, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (15, 15, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (16, 16, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (17, 17, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (18, 18, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (19, 19, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (20, 20, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (21, 21, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (22, 22, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (23, 23, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (24, 24, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (25, 25, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (26, 26, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (27, 27, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (28, 28, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (29, 29, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (30, 30, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (31, 31, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (32, 32, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (33, 33, 1)
INSERT [dbo].[alumnos_materias] ([alumnos_materias], [id_alumnos], [id_materias]) VALUES (34, 34, 1)
INSERT [dbo].[clave] ([clave], [activo]) VALUES (N'D25L7', 0)
INSERT [dbo].[maestros] ([id_maestros], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (1, N'Amalia Neira', N'Leticia', 1, N'F65LGYA4CA')
INSERT [dbo].[maestros] ([id_maestros], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (99, N'demo', N'demo', 3, N'123456')
INSERT [dbo].[materias] ([id_materias], [materia]) VALUES (1, N'Administracion de Proyectos de Software')
INSERT [dbo].[tipo_usuarios] ([tipo_usuario], [descripcion]) VALUES (1, N'maestros')
INSERT [dbo].[tipo_usuarios] ([tipo_usuario], [descripcion]) VALUES (2, N'alumnos')
INSERT [dbo].[tipo_usuarios] ([tipo_usuario], [descripcion]) VALUES (3, N'administrador')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (1, N'0', N'Amalia Neira', N'Leticia', 1, N'F65LGYA4CA')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (2, N'1745920', N'Alvarez Ruiz', N'Saul Osvaldo', 2, N'SYCI9KFELM')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (3, N'1796895', N'Cavazos Guzman', N'Oziel Alejandro', 2, N'9VHQIVMQII')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (4, N'1803993', N'Contreras Torres', N'Reynaldo', 2, N' KIV66NNMP4')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (5, N'1675786', N'De La Fuente Aguayo', N'Mauricio Javier', 2, N'V1METGCFGN')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (6, N'1793929', N'De La Rosa Medina', N'Milton Javier', 2, N'HNHI5RM6CH')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (7, N'1799114', N'Dominguez Azueta', N'Nidia Estefania', 2, N'3ACEGRP8DQ')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (8, N'1748613', N'Esparza Ramos', N'Kenneth Sajid', 2, N'4QZODRW736')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (9, N'1755663', N'Fuentes Marquez', N'Javier Romario', 2, N'KB7PDZLC2A')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (10, N'1889467', N'Garcia Ballesteros', N'Miguel Angel', 2, N'2IMWHBCQOY')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (11, N'1813150', N'Garcia Roque', N'Miguel Angel', 2, N'BDF27H9KPJ')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (12, N'1488273', N'Gonzalez Salazar', N'Jorge Luis', 2, N'OV0MJMMOMW')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (13, N'1677529', N'Guerrero Reyes', N'Angel Missael', 2, N'KFVS7M1FBY')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (14, N'1807983', N'Gutierrez Rodriguez', N'Fausto Martin', 2, N'VU9M2GN3Q0')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (15, N'1753891', N'Hernandez Alonso', N'Cecilia Lizbeth', 2, N'981JOG813C')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (16, N'1810972', N'Ibarra Barrientos', N'Edgar Alejandro', 2, N'0MH1NM1YZ8')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (17, N'1798180', N'Juarez Vega', N'Axel Rosario', 2, N'ADB67DMF2I')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (18, N'1669378', N'Llanas Perez', N'Hector Jesus', 2, N'M4WD1XWBKA')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (19, N'1751483', N'Lopez Gomez', N'Humberto Salvador', 2, N'G1GVEPXYVT')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (20, N'1746638', N'Lozano Lomas', N'Sharon Berenice', 2, N'TJ3V8TRAB6')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (21, N'1685707', N'Macias Cabrales', N'Alejandra Carolina', 2, N'HFCTKJS8GL')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (22, N'1810911', N'Martinez Flores', N'Jorge Adrian', 2, N'JUGTXV7V3J')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (23, N'1681075', N'Perez Gallardo', N'Moises Alejandro', 2, N'JX20ZMFDFY')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (24, N'1739955', N'Picazzo Casillas', N'Ricardo Arturo', 2, N'58SVU864QA')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (25, N'1662083', N'Rebolloso Garcia', N'Enrique Alejandro', 2, N'OWC0SUQN5U')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (26, N'1738673', N'Rodriguez Palacios', N'Jose Guadalupe', 2, N'G11B36NGPP')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (27, N'1733781', N'Sanchez Garcia', N'Jose Ignacio', 2, N'V7MG0FGZ2V')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (28, N'1736733', N'Silva Beltrán', N'Felix Adan', 2, N'AOM54ZWB44')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (29, N'1724180', N'Silva Garza', N'Oziel Alejandro', 2, N'ZI9UP4FT07')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (30, N'1768129', N'Soto Cansino', N'Juan Jose', 2, N'OT6SONZOWT')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (31, N'1873930', N'Treviño Paez', N'Gustavo', 2, N'JTIM6G4NJ1')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (32, N'1794331', N'Vega Aleman', N'Jose Gabriel Tadeo', 2, N'NHOLMCCPPD')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (33, N'1676372', N'Velez Quintanar', N'Nestor Oziel', 2, N'IWPAMI0P1S')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (34, N'1810492', N'Vitela Rodriguez', N'Vania Janeli', 2, N'2AF00CA08O')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (35, N'1741500', N'Zapata Santiago', N'Jorge Antonio', 2, N'XQGCJE9FZU')
INSERT [dbo].[usuarios] ([id_usuario], [matricula], [apellidos], [nombres], [tipo_usuario], [password]) VALUES (99, N'1', N'Administrador', N'Administrador', 3, N'4dm1n')
/****** Object:  StoredProcedure [dbo].[desactivar_clave]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[desactivar_clave]
as
set nocount on 
update clave
set activo = 0
GO
/****** Object:  StoredProcedure [dbo].[generador_random]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[generador_random]
as 
set nocount on

SELECT dbo.fnCustomPass(10,'CN')
GO
/****** Object:  StoredProcedure [dbo].[generar_clave_nueva]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[generar_clave_nueva]
as
set nocount on
update clave 
set
clave = (SELECT dbo.fnCustomPass(5,'CN')), activo = 1
GO
/****** Object:  StoredProcedure [dbo].[in_alumno_por_materia]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[in_alumno_por_materia]
@id_alumnos int,
@id_materias int
as
set nocount on 
declare @alumnos_materias int
set @alumnos_materias = (select max(alumnos_materias) from alumnos_materias) + 1      
insert into alumnos_materias    
(alumnos_materias, id_alumnos, id_materias)    
values     
(@alumnos_materias, @id_alumnos, @id_materias)
GO
/****** Object:  StoredProcedure [dbo].[in_maestros]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[in_maestros]    
@apellidos varchar(50),    
@nombres varchar(50),
@tipo int,  
@password varchar(50)   
as     
set nocount on     
declare @id_maestros int    
set @id_maestros = (select max(id_maestros) from maestros) + 1    
insert into maestros    
(id_maestros, apellidos, nombres, tipo_usuario, password)    
values     
(@id_maestros, @apellidos, @nombres, @tipo, @password)
GO
/****** Object:  StoredProcedure [dbo].[in_usuarios]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[in_usuarios]
@matricula varchar(10),
@apedillos varchar(50),
@nombres varchar(50),
@tipo_usuario int,
@password varchar(50)
as
set nocount on 

declare @id_usuario int
set @id_usuario = (select max(id_usuario) from usuarios) + 1

insert into usuarios 
(id_usuario, matricula, apellidos, nombres, tipo_usuario, password)
values
(@id_usuario, @matricula, @apedillos, @nombres, @tipo_usuario, @password)
GO
/****** Object:  StoredProcedure [dbo].[sl_alumnos]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sl_alumnos]
as
set nocount on 
select matricula, apellidos, nombres, tipo_usuario 
from alumnos
GO
/****** Object:  StoredProcedure [dbo].[sl_usuarios]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sl_usuarios]
as  
set nocount on   
select id_usuario,
matricula,
apellidos,
nombres,
tipo_usuario,
password
from usuarios
GO
/****** Object:  StoredProcedure [dbo].[sl_usuarios_por_usuario]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sl_usuarios_por_usuario]
@id_usuario int
as 
set nocount on 
select id_usuario,
matricula, 
apellidos,
nombres,
tipo_usuario,
password
from usuarios
where @id_usuario = id_usuario
GO
/****** Object:  StoredProcedure [dbo].[usuarios_login]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usuarios_login]    
 @matricula varchar(50)          
AS          
BEGIN          
 SET NOCOUNT ON;    
 select convert(varchar(30), id_usuario) as usuariostring,   
id_usuario,
matricula,
apellidos,
nombres,
tipo_usuario,
password
from usuarios         
 where matricula = @matricula          
END
GO
/****** Object:  StoredProcedure [dbo].[valida_usuario]    Script Date: 4/22/2020 6:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[valida_usuario]
@matricula NVARCHAR(20),
@password NVARCHAR(20)
as
BEGIN
set nocount on;
DECLARE @id_usuario int    
      
SELECT @id_usuario = id_usuario --Este es un entero matricula
FROM usuarios WHERE matricula = @matricula AND password = @password  
IF @id_usuario IS NOT NULL
      BEGIN
            IF EXISTS(SELECT id_usuario FROM usuarios WHERE matricula = @matricula)
				BEGIN
                  SELECT @id_usuario-- User Valid
				END
			ELSE
			BEGIN
				SELECT -2 -- User not activated.
			END
	 END
     ELSE
		BEGIN
            SELECT -1 -- User invalid.
        END
END
GO
USE [master]
GO
ALTER DATABASE [QuickList] SET  READ_WRITE 
GO
