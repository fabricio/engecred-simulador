-- ============================================
-- Script de Criação e População do Banco de Dados
-- Simulador de Crédito - SICOOB (Versão SQL Server)
-- ============================================

-- Verifica se existe o banco 
IF NOT EXISTS (
    SELECT name FROM sys.databases WHERE name = N'SimuladorCredito'
)
-- Criar banco de dados
BEGIN
    CREATE DATABASE SimuladorCredito;
END
GO

USE SimuladorCredito;
GO

-- ============================================
-- CRIAÇÃO DAS TABELAS
-- ============================================

-- Tabela de Segmentos
CREATE TABLE Segments (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Code VARCHAR(10) NOT NULL UNIQUE,
    Name VARCHAR(100) NOT NULL,
    PersonType VARCHAR(2) NOT NULL CHECK (PersonType IN ('PF', 'PJ')),
    MinAnnualIncome DECIMAL(18,2) NOT NULL
);

-- Tabela de Produtos
CREATE TABLE Products (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    PersonType VARCHAR(2) NOT NULL CHECK (PersonType IN ('PF', 'PJ')),
    Modality VARCHAR(20) NOT NULL CHECK (Modality IN ('Pre-fixado', 'Pos-fixado'))
);

-- Tabela de Taxas
CREATE TABLE Rates (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ProductId INT NOT NULL,
    SegmentId INT NOT NULL,
    Rate DECIMAL(10,6) NULL, -- NULL = não disponível
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Rates_Products FOREIGN KEY (ProductId) REFERENCES Products(Id),
    CONSTRAINT FK_Rates_Segments FOREIGN KEY (SegmentId) REFERENCES Segments(Id),
    CONSTRAINT UQ_Rates_Product_Segment UNIQUE(ProductId, SegmentId)
);

-- ============================================
-- ÍNDICES PARA PERFORMANCE
-- ============================================

CREATE INDEX IX_Segments_PersonType_MinIncome ON Segments(PersonType, MinAnnualIncome);
CREATE INDEX IX_Products_PersonType_Modality ON Products(PersonType, Modality);
CREATE INDEX IX_Rates_ProductId_SegmentId ON Rates(ProductId, SegmentId);

-- ============================================
-- POPULAÇÃO DOS DADOS
-- ============================================

-- Inserir Segmentos
INSERT INTO Segments (Code, Name, PersonType, MinAnnualIncome) VALUES
('PF1', 'Basico', 'PF', 0),
('PF2', 'Intermediario', 'PF', 2000),
('PF3', 'Premium', 'PF', 20000),
('PF4', 'Black', 'PF', 200000),
('PJ1', 'MEI', 'PJ', 0),
('PJ2', 'Empresarial', 'PJ', 4000),
('PJ3', 'Corporativo', 'PJ', 400000),
('PJ4', 'Enterprise', 'PJ', 40000000);

-- Inserir Produtos
INSERT INTO Products (Name, PersonType, Modality) VALUES
-- Pessoa fisica - Pre-fixado
('Financiamento', 'PF', 'Pre-fixado'),
('Sicoob engecred consignado', 'PF', 'Pre-fixado'),
('Emprestimo pessoal', 'PF', 'Pre-fixado'),
('Imoveis', 'PF', 'Pre-fixado'),
-- Pessoa fisica - Pos-fixado
('Financiamento', 'PF', 'Pos-fixado'),
('Sicoob engecred consignado', 'PF', 'Pos-fixado'),
('Emprestimo pessoal', 'PF', 'Pos-fixado'),
('Imoveis', 'PF', 'Pos-fixado'),
-- Pessoa juridica - Pre-fixado
('Financiamento', 'PJ', 'Pre-fixado'),
('Credito rural', 'PJ', 'Pre-fixado'),
('Emprestimo pessoal', 'PJ', 'Pre-fixado'),
('Imoveis', 'PJ', 'Pre-fixado'),
-- Pessoa juridica - Pos-fixado
('Financiamento', 'PJ', 'Pos-fixado'),
('Credito rural', 'PJ', 'Pos-fixado'),
('Emprestimo pessoal', 'PJ', 'Pos-fixado'),
('Imoveis', 'PJ', 'Pos-fixado');

-- ============================================
-- INSERIR TAXAS
-- ============================================

-- TAXAS PARA Pessoa fisica - Pre-fixado
INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.10
FROM Products p, Segments s
WHERE p.Name = 'Financiamento' AND p.PersonType = 'PF' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PF1';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.09
FROM Products p, Segments s
WHERE p.Name = 'Financiamento' AND p.PersonType = 'PF' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PF2';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.08
FROM Products p, Segments s
WHERE p.Name = 'Financiamento' AND p.PersonType = 'PF' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PF3';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.07
FROM Products p, Segments s
WHERE p.Name = 'Financiamento' AND p.PersonType = 'PF' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PF4';

-- Sicoob engecred consignado PF Pre-fixado (Não disponível)
INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, NULL
FROM Products p, Segments s
WHERE p.Name = 'Sicoob engecred consignado' AND p.PersonType = 'PF' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PF1';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, NULL
FROM Products p, Segments s
WHERE p.Name = 'Sicoob engecred consignado' AND p.PersonType = 'PF' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PF2';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, NULL
FROM Products p, Segments s
WHERE p.Name = 'Sicoob engecred consignado' AND p.PersonType = 'PF' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PF3';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, NULL
FROM Products p, Segments s
WHERE p.Name = 'Sicoob engecred consignado' AND p.PersonType = 'PF' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PF4';

-- Emprestimo pessoal PF Pre-fixado
INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.09
FROM Products p, Segments s
WHERE p.Name = 'Emprestimo pessoal' AND p.PersonType = 'PF' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PF1';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.08
FROM Products p, Segments s
WHERE p.Name = 'Emprestimo pessoal' AND p.PersonType = 'PF' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PF2';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.07
FROM Products p, Segments s
WHERE p.Name = 'Emprestimo pessoal' AND p.PersonType = 'PF' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PF3';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.06
FROM Products p, Segments s
WHERE p.Name = 'Emprestimo pessoal' AND p.PersonType = 'PF' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PF4';

-- Imoveis PF Pre-fixado
INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.20
FROM Products p, Segments s
WHERE p.Name = 'Imoveis' AND p.PersonType = 'PF' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PF1';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.25
FROM Products p, Segments s
WHERE p.Name = 'Imoveis' AND p.PersonType = 'PF' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PF2';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.30
FROM Products p, Segments s
WHERE p.Name = 'Imoveis' AND p.PersonType = 'PF' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PF3';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.35
FROM Products p, Segments s
WHERE p.Name = 'Imoveis' AND p.PersonType = 'PF' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PF4';

-- ============================================
-- TAXAS PARA Pessoa fisica - Pos-fixado
-- ============================================

-- Financiamento PF Pos-fixado
INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.06
FROM Products p, Segments s
WHERE p.Name = 'Financiamento' AND p.PersonType = 'PF' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PF1';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.05
FROM Products p, Segments s
WHERE p.Name = 'Financiamento' AND p.PersonType = 'PF' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PF2';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.04
FROM Products p, Segments s
WHERE p.Name = 'Financiamento' AND p.PersonType = 'PF' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PF3';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.03
FROM Products p, Segments s
WHERE p.Name = 'Financiamento' AND p.PersonType = 'PF' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PF4';

-- Sicoob engecred consignado PF Pos-fixado
INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.05
FROM Products p, Segments s
WHERE p.Name = 'Sicoob engecred consignado' AND p.PersonType = 'PF' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PF1';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.04
FROM Products p, Segments s
WHERE p.Name = 'Sicoob engecred consignado' AND p.PersonType = 'PF' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PF2';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.03
FROM Products p, Segments s
WHERE p.Name = 'Sicoob engecred consignado' AND p.PersonType = 'PF' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PF3';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.02
FROM Products p, Segments s
WHERE p.Name = 'Sicoob engecred consignado' AND p.PersonType = 'PF' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PF4';

-- Emprestimo pessoal PF Pos-fixado
INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.05
FROM Products p, Segments s
WHERE p.Name = 'Emprestimo pessoal' AND p.PersonType = 'PF' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PF1';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.04
FROM Products p, Segments s
WHERE p.Name = 'Emprestimo pessoal' AND p.PersonType = 'PF' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PF2';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.03
FROM Products p, Segments s
WHERE p.Name = 'Emprestimo pessoal' AND p.PersonType = 'PF' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PF3';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.02
FROM Products p, Segments s
WHERE p.Name = 'Emprestimo pessoal' AND p.PersonType = 'PF' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PF4';

-- Imoveis PF Pos-fixado
INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.40
FROM Products p, Segments s
WHERE p.Name = 'Imoveis' AND p.PersonType = 'PF' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PF1';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.45
FROM Products p, Segments s
WHERE p.Name = 'Imoveis' AND p.PersonType = 'PF' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PF2';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.50
FROM Products p, Segments s
WHERE p.Name = 'Imoveis' AND p.PersonType = 'PF' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PF3';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.55
FROM Products p, Segments s
WHERE p.Name = 'Imoveis' AND p.PersonType = 'PF' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PF4';

-- ============================================
-- TAXAS PARA Pessoa juridica - Pre-fixado
-- ============================================

-- Financiamento PJ Pre-fixado
INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.10
FROM Products p, Segments s
WHERE p.Name = 'Financiamento' AND p.PersonType = 'PJ' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PJ1';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.09
FROM Products p, Segments s
WHERE p.Name = 'Financiamento' AND p.PersonType = 'PJ' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PJ2';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.08
FROM Products p, Segments s
WHERE p.Name = 'Financiamento' AND p.PersonType = 'PJ' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PJ3';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.07
FROM Products p, Segments s
WHERE p.Name = 'Financiamento' AND p.PersonType = 'PJ' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PJ4';

-- Credito rural PJ Pre-fixado
INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.05
FROM Products p, Segments s
WHERE p.Name = 'Credito rural' AND p.PersonType = 'PJ' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PJ1';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.04
FROM Products p, Segments s
WHERE p.Name = 'Credito rural' AND p.PersonType = 'PJ' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PJ2';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.03
FROM Products p, Segments s
WHERE p.Name = 'Credito rural' AND p.PersonType = 'PJ' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PJ3';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.02
FROM Products p, Segments s
WHERE p.Name = 'Credito rural' AND p.PersonType = 'PJ' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PJ4';

-- Emprestimo pessoal PJ Pre-fixado
INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.09
FROM Products p, Segments s
WHERE p.Name = 'Emprestimo pessoal' AND p.PersonType = 'PJ' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PJ1';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.08
FROM Products p, Segments s
WHERE p.Name = 'Emprestimo pessoal' AND p.PersonType = 'PJ' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PJ2';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.07
FROM Products p, Segments s
WHERE p.Name = 'Emprestimo pessoal' AND p.PersonType = 'PJ' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PJ3';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.06
FROM Products p, Segments s
WHERE p.Name = 'Emprestimo pessoal' AND p.PersonType = 'PJ' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PJ4';

-- Imoveis PJ Pre-fixado
INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.20
FROM Products p, Segments s
WHERE p.Name = 'Imoveis' AND p.PersonType = 'PJ' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PJ1';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.25
FROM Products p, Segments s
WHERE p.Name = 'Imoveis' AND p.PersonType = 'PJ' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PJ2';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.30
FROM Products p, Segments s
WHERE p.Name = 'Imoveis' AND p.PersonType = 'PJ' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PJ3';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.35
FROM Products p, Segments s
WHERE p.Name = 'Imoveis' AND p.PersonType = 'PJ' AND p.Modality = 'Pre-fixado'
AND s.Code = 'PJ4';

-- ============================================
-- TAXAS PARA Pessoa juridica - Pos-fixado
-- ============================================

-- Financiamento PJ Pos-fixado
INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.06
FROM Products p, Segments s
WHERE p.Name = 'Financiamento' AND p.PersonType = 'PJ' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PJ1';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.05
FROM Products p, Segments s
WHERE p.Name = 'Financiamento' AND p.PersonType = 'PJ' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PJ2';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.04
FROM Products p, Segments s
WHERE p.Name = 'Financiamento' AND p.PersonType = 'PJ' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PJ3';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.03
FROM Products p, Segments s
WHERE p.Name = 'Financiamento' AND p.PersonType = 'PJ' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PJ4';

-- Credito rural PJ Pos-fixado
INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.01
FROM Products p, Segments s
WHERE p.Name = 'Credito rural' AND p.PersonType = 'PJ' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PJ1';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.005
FROM Products p, Segments s
WHERE p.Name = 'Credito rural' AND p.PersonType = 'PJ' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PJ2';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.005
FROM Products p, Segments s
WHERE p.Name = 'Credito rural' AND p.PersonType = 'PJ' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PJ3';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.003
FROM Products p, Segments s
WHERE p.Name = 'Credito rural' AND p.PersonType = 'PJ' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PJ4';

-- Emprestimo pessoal PJ Pos-fixado
INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.05
FROM Products p, Segments s
WHERE p.Name = 'Emprestimo pessoal' AND p.PersonType = 'PJ' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PJ1';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.04
FROM Products p, Segments s
WHERE p.Name = 'Emprestimo pessoal' AND p.PersonType = 'PJ' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PJ2';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.03
FROM Products p, Segments s
WHERE p.Name = 'Emprestimo pessoal' AND p.PersonType = 'PJ' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PJ3';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.02
FROM Products p, Segments s
WHERE p.Name = 'Emprestimo pessoal' AND p.PersonType = 'PJ' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PJ4';

-- Imoveis PJ Pos-fixado
INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.40
FROM Products p, Segments s
WHERE p.Name = 'Imoveis' AND p.PersonType = 'PJ' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PJ1';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.45
FROM Products p, Segments s
WHERE p.Name = 'Imoveis' AND p.PersonType = 'PJ' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PJ2';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.50
FROM Products p, Segments s
WHERE p.Name = 'Imoveis' AND p.PersonType = 'PJ' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PJ3';

INSERT INTO Rates (ProductId, SegmentId, Rate)
SELECT p.Id, s.Id, 0.55
FROM Products p, Segments s
WHERE p.Name = 'Imoveis' AND p.PersonType = 'PJ' AND p.Modality = 'Pos-fixado'
AND s.Code = 'PJ4';