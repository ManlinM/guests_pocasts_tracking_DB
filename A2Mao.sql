
-- Topic:Podcasting company guests and podcasts tracking db

-- Name:Manlin Mao
DROP DATABASE IF EXISTS A2Manlin;
CREATE	DATABASE A2Manlin;

USE A2Manlin;

-- 1st M:N table
CREATE TABLE podcasts
(
	podcastsID              INT       PRIMARY KEY,
    podcastsTitle           VARCHAR(120),
    podcastsYrReleased      YEAR,
    podcastNbrGuests        INT
    );
    
INSERT INTO podcasts VALUES
(10,'The Happiness Lab', 2022,2),
(11,'Tiny Leaps, Big Changes', 2019,1),
(12,'Not Another Anxiety Show', 2020,2),
(13,'Beyond the To-Do List', 2020,2),
(14,'The Chasing Joy Podcast', 2021,2),
(15,'Under the Skin', 2022,NULL); -- no guets store with this podcast yet

-- 1:1 table, related table of podcasts 
CREATE TABLE podcastsType 
(
	podcastsID           INT        PRIMARY KEY, 
    podcastsTopics       VARCHAR(100),
    podcastsFormat       VARCHAR(80),
    
		CONSTRAINT podcasts_fk_podcastsType  
			FOREIGN KEY(podcastsID) 
            REFERENCES podcasts(podcastsID)
);

INSERT INTO podcastsType VALUES
(10,'Self-Help for General Happiness', 'Interview'),
(11,'Self-Help for Building New Habits', 'Monologue'),
(12,'Self-Help for Anxiety', 'Nonfiction'),
(13,'Self-Help for Procrastination', 'Conversational'),
(14,'Self-Help for Spiritual', 'Fiction'),
(15,'Self-Help for Depressions', 'Theatrical');

-- 2nd M:N table
CREATE TABLE guests
(
	guestsID              INT       PRIMARY KEY,
    guestsFName           VARCHAR(100),
    guestsLName           VARCHAR(100),
    guestsProfession      VARCHAR(120),
    guestsHrlyRate        DECIMAL(4,2),
    guestsHrsWorked       INT
    );
    
INSERT INTO guests VALUES
(1,'Laurie', 'Santos','Professor of Psychology',41.96,80),
(2,'Adam', 'Grant','Writer',33.83,35),
(3,'Gregg', 'Clunis ','Entrepreneur',40.12,40),
(4,'Kelli ', 'Walker','Podcaster',30.15,15),
(5,'Georgie', 'Morley','Photographer',32.55,42);

-- linking table
CREATE TABLE podcastsGuests
( 
    podcastsID             INT,
	guestsID               INT,
    podcastInflcerOfYr     BOOLEAN,
    
    PRIMARY KEY(podcastsID, guestsID), 
    
    FOREIGN KEY(podcastsID)
		REFERENCES podcasts(podcastsID),
	FOREIGN KEY(guestsID)
		REFERENCES guests(guestsID)
	
);

 INSERT INTO podcastsGuests VALUE
	(10,1,FALSE),
	(10,4,TRUE),
	(11,3,TRUE),
	(12,4,FALSE),
    (12,5,TRUE),
    (13,2,FALSE),
    (13,5,FALSE),
    (14,5,FALSE),
    (14,2,FALSE);

-- Query 1:
/*SELECT podcastsTopics,podcastsFormat,podcastsTitle,podcastsYrReleased
FROM podcasts p
	JOIN podcastsType pt
		ON p.podcastsID = pt.podcastsID
WHERE podcastsTitle LIKE 'T%';

-- Query 2:
SELECT guestsLName, guestsHrlyRate, guestsHrsWorked, guestsHrlyRate* guestsHrsWorked AS guestSalary
FROM guests
ORDER BY guestSalary DESC;

-- Query 3: 
SELECT podcastsTitle
FROM podcasts p
	LEFT JOIN podcastsguests pg
		ON p.podcastsID = pg.podcastsID
	LEFT JOIN guests g
		ON g.guestsID = pg.guestsID
WHERE g.guestsID IS NULL;

-- Query 4:
SELECT guestsFName,podcastsTitle, podcastsTopics
FROM podcasts p
	JOIN podcastsguests pg
		ON p.podcastsID = pg.podcastsID
	JOIN guests g
		ON g.guestsID = pg.guestsID
	JOIN podcaststype pt
		ON p.podcastsID = pt.podcastsID
ORDER BY guestsFName;
