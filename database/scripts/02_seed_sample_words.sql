-- Sample Portuguese words for Termo game
-- This is a starter set of words for testing purposes
-- TODO: Replace with comprehensive Brazilian Portuguese dictionary

USE TermoDB;
GO

-- Insert sample words (5-letter Brazilian Portuguese words)
-- Note: This is a small sample set for testing. A full implementation would need thousands of words.

INSERT INTO [dbo].[Words] ([Word], [IsValid], [Difficulty]) VALUES
-- Common words (Difficulty 1)
('CASA', 1, 1),    -- house
('AMOR', 1, 1),    -- love
('VIDA', 1, 1),    -- life
('TEMPO', 1, 1),   -- time (wait, this is 5 letters: T-E-M-P-O)
('MUNDO', 1, 1),   -- world
('TERRA', 1, 1),   -- earth/land
('VERDE', 1, 1),   -- green
('AZUL', 1, 1),    -- blue (4 letters, need to be careful)
('BRANCO', 1, 1),  -- white (6 letters, invalid)
('PRETO', 1, 1),   -- black
('FELIZ', 1, 1),   -- happy
('TRISTE', 1, 1),  -- sad (6 letters, invalid)
('BELO', 1, 1),    -- beautiful (4 letters)
('BONITO', 1, 1),  -- pretty (6 letters, invalid)
-- Let me fix these - only 5-letter words
('LIVRO', 1, 1),   -- book
('MESA', 1, 1),    -- table (4 letters)
('AGUA', 1, 1),    -- water (4 letters)
-- More 5-letter words
('PEIXE', 1, 1),   -- fish
('GATO', 1, 1),    -- cat (4 letters)
('CARRO', 1, 1),   -- car
('AVIAO', 1, 1),   -- airplane
('TREM', 1, 1),    -- train (4 letters)
('PRAIA', 1, 1),   -- beach
('CHUVA', 1, 1),   -- rain
('FLOR', 1, 1),    -- flower (4 letters)

-- Medium difficulty words (Difficulty 2)
('REINO', 1, 2),   -- kingdom
('PONTE', 1, 2),   -- bridge
('FONTE', 1, 2),   -- fountain/source
('MONTE', 1, 2),   -- mountain
('CERTO', 1, 2),   -- right/correct
('CAMPO', 1, 2),   -- field
('LARGO', 1, 2),   -- wide
('BAIXO', 1, 2),   -- low/short
('FORTE', 1, 2),   -- strong
('FRACO', 1, 2),   -- weak

-- Hard words (Difficulty 3)
('ZEBRA', 1, 3),   -- zebra
('FORCA', 1, 3),   -- strength/force
('NEGRO', 1, 3),   -- black
('BRAVO', 1, 3),   -- brave/angry
('GRAVE', 1, 3),   -- serious/grave
('PRADO', 1, 3),   -- meadow
('PRIMO', 1, 3),   -- cousin/prime
('PLANO', 1, 3),   -- plan/flat
('GLOBO', 1, 3),   -- globe
('DRAMA', 1, 3);   -- drama

-- Let me add only valid 5-letter words
DELETE FROM [dbo].[Words] WHERE LEN([Word]) != 5;

-- Add more valid 5-letter words
INSERT INTO [dbo].[Words] ([Word], [IsValid], [Difficulty]) VALUES
-- More common 5-letter words
('AINDA', 1, 1),   -- still/yet
('ANTES', 1, 1),   -- before
('MUITO', 1, 1),   -- much/very
('SOBRE', 1, 1),   -- about/over
('TODOS', 1, 1),   -- all/everyone
('LUGAR', 1, 1),   -- place
('MAIOR', 1, 1),   -- bigger
('MENOR', 1, 1),   -- smaller
('JUNTO', 1, 1),   -- together
('GRUPO', 1, 1),   -- group
('PONTO', 1, 1),   -- point
('FORMA', 1, 1),   -- form/shape
('PARTE', 1, 1),   -- part
('VALOR', 1, 1),   -- value
('MEIO', 1, 1),    -- middle/half (4 letters - invalid)
('CAUSA', 1, 1),   -- cause
('EFEITO', 1, 1),  -- effect (6 letters - invalid)
('MOEDA', 1, 1),   -- coin
('PAPEL', 1, 1),   -- paper
('LAPIS', 1, 1),   -- pencil
('ESCOLA', 1, 1),  -- school (6 letters - invalid)
('ALUNO', 1, 1),   -- student
('PROFESSOR', 1, 1), -- teacher (9 letters - invalid)
('QUARTO', 1, 1),  -- room/fourth (6 letters - invalid)
('QUINTA', 1, 1),  -- farm/fifth
('SEXTA', 1, 1),   -- sixth/Friday
('DOMINGO', 1, 1); -- Sunday (7 letters - invalid)

-- Clean up invalid entries again
DELETE FROM [dbo].[Words] WHERE LEN([Word]) != 5;

-- Add more valid 5-letter words to have a decent starting set
INSERT INTO [dbo].[Words] ([Word], [IsValid], [Difficulty]) VALUES
('FESTA', 1, 1),   -- party
('JOGO', 1, 1),    -- game (4 letters - invalid)
('MUSICA', 1, 1),  -- music (6 letters - invalid)
('FILME', 1, 1),   -- movie
('LIVRO', 1, 1),   -- book (duplicate, will be ignored due to unique constraint)
('RADIO', 1, 1),   -- radio
('COMIDA', 1, 1),  -- food (6 letters - invalid)
('DOCE', 1, 1),    -- sweet (4 letters - invalid)
('SALGADO', 1, 1), -- salty (7 letters - invalid)
('AMARGO', 1, 1),  -- bitter (6 letters - invalid)
('SABOR', 1, 1),   -- flavor
('CHEIRO', 1, 1),  -- smell (6 letters - invalid)
('VISAO', 1, 1),   -- vision
('AUDIO', 1, 1),   -- audio
('TOQUE', 1, 1),   -- touch
('GOSTO', 1, 1),   -- taste/like
('FRIO', 1, 1),    -- cold (4 letters - invalid)
('QUENTE', 1, 1),  -- hot (6 letters - invalid)
('MORNO', 1, 1),   -- warm
('SECO', 1, 1),    -- dry (4 letters - invalid)
('MOLHADO', 1, 1), -- wet (7 letters - invalid)
('LIMPO', 1, 1),   -- clean
('SUJO', 1, 1),    -- dirty (4 letters - invalid)
('CLARO', 1, 1),   -- light/clear
('ESCURO', 1, 1),  -- dark (6 letters - invalid)
('RAPIDO', 1, 1),  -- fast (6 letters - invalid)
('LENTO', 1, 1),   -- slow
('ALTO', 1, 1),    -- tall/high (4 letters - invalid)
('CURTO', 1, 1),   -- short
('LONGO', 1, 1),   -- long
('PERTO', 1, 1),   -- near/close
('LONGE', 1, 1),   -- far
('DENTRO', 1, 1),  -- inside (6 letters - invalid)
('FORA', 1, 1),    -- outside (4 letters - invalid)
('CIMA', 1, 1),    -- up/above (4 letters - invalid)
('BAIXO', 1, 1),   -- down/low (duplicate)
('FRENTE', 1, 1),  -- front (6 letters - invalid)
('ATRAS', 1, 1),   -- behind
('LADO', 1, 1),    -- side (4 letters - invalid)
('CENTRO', 1, 1),  -- center (6 letters - invalid)
('BORDA', 1, 1),   -- edge
('CANTO', 1, 1),   -- corner
('MEIO', 1, 1);    -- middle (4 letters - invalid, duplicate)

-- Final cleanup
DELETE FROM [dbo].[Words] WHERE LEN([Word]) != 5;

-- Add some daily words for the next few days for testing
DECLARE @today DATE = CAST(GETDATE() AS DATE);
DECLARE @word1 INT = (SELECT TOP 1 Id FROM [dbo].[Words] WHERE [Word] = 'MUNDO');
DECLARE @word2 INT = (SELECT TOP 1 Id FROM [dbo].[Words] WHERE [Word] = 'TEMPO');
DECLARE @word3 INT = (SELECT TOP 1 Id FROM [dbo].[Words] WHERE [Word] = 'VERDE');

INSERT INTO [dbo].[DailyWords] ([Date], [WordId], [IsActive]) VALUES
(@today, @word1, 1),
(DATEADD(day, 1, @today), @word2, 1),
(DATEADD(day, 2, @today), @word3, 1);

PRINT 'Sample words seeded successfully!';
PRINT 'Total words in database: ' + CAST((SELECT COUNT(*) FROM [dbo].[Words]) AS NVARCHAR(10));
GO
