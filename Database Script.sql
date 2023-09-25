--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 15rc2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: Project1; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "Project1" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Arabic_Egypt.1252';


ALTER DATABASE "Project1" OWNER TO postgres;

\connect "Project1"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: blog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blog (
    blog_id character varying(200) DEFAULT concat('a', public.uuid_generate_v4()) NOT NULL,
    blog_title character varying(200) NOT NULL,
    description text NOT NULL,
    date_posted date DEFAULT (now())::date,
    user_id character varying(200),
    book_id character varying(200),
    CONSTRAINT blog_description_check CHECK ((description <> ''::text)),
    CONSTRAINT blog_title_check CHECK (((blog_title)::text <> ''::text))
);


ALTER TABLE public.blog OWNER TO postgres;

--
-- Name: book; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book (
    book_id character varying(200) DEFAULT concat('a', public.uuid_generate_v4()) NOT NULL,
    price real NOT NULL,
    title character varying(200) NOT NULL,
    date_published date DEFAULT (now())::date NOT NULL,
    chapters integer DEFAULT 1,
    sequel character varying(200),
    part integer DEFAULT 1,
    rating smallint DEFAULT 5,
    age_rating smallint DEFAULT 1,
    accepted boolean DEFAULT false,
    is_borrow boolean DEFAULT false,
    description text NOT NULL,
    photo text DEFAULT 'https://www.adobe.com/express/discover/ideas/media_110fb8e290d4ad589cc095e1477bc30064f972deb.png?width=750&format=png&optimize=medium'::text,
    CONSTRAINT book_age_rating_check CHECK ((age_rating > 0)),
    CONSTRAINT book_chapters_check CHECK ((chapters > 0)),
    CONSTRAINT book_description_check CHECK ((description <> ''::text)),
    CONSTRAINT book_part_check CHECK ((part > 0)),
    CONSTRAINT book_price_check CHECK ((price > (0)::double precision)),
    CONSTRAINT book_rating_check CHECK (((rating >= 0) AND (rating <= 5))),
    CONSTRAINT book_sequel_check CHECK (((sequel)::text <> ''::text)),
    CONSTRAINT book_title_check CHECK (((title)::text <> ''::text))
);


ALTER TABLE public.book OWNER TO postgres;

--
-- Name: book_tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book_tag (
    book_id character varying(200) NOT NULL,
    tag_id character varying(50) NOT NULL
);


ALTER TABLE public.book_tag OWNER TO postgres;

--
-- Name: borrow; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.borrow (
    user_id character varying(200) NOT NULL,
    book_id character varying(200) NOT NULL,
    return_date date DEFAULT ((now())::date + 7) NOT NULL,
    returned boolean DEFAULT false
);


ALTER TABLE public.borrow OWNER TO postgres;

--
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    event_id character varying(200) DEFAULT concat('a', public.uuid_generate_v4()) NOT NULL,
    place character varying(200) NOT NULL,
    tickets integer NOT NULL,
    ticket_price real NOT NULL,
    title character varying(200) NOT NULL,
    due_to date NOT NULL,
    description text NOT NULL,
    event_photo text DEFAULT 'https://media.discordapp.net/attachments/916775831064424478/1053701343694573688/pexels-caleb-oquendo-3023317.jpg?width=994&height=663'::text,
    CONSTRAINT events_description_check CHECK ((description <> ''::text)),
    CONSTRAINT events_place_check CHECK ((((place)::text ~ '^[a-zA-Z0-9.,:;!?#-]+$'::text) AND ((place)::text <> ''::text))),
    CONSTRAINT events_ticket_price_check CHECK ((ticket_price > (0)::double precision)),
    CONSTRAINT events_tickets_check CHECK ((tickets > 0)),
    CONSTRAINT events_title_check CHECK (((title)::text <> ''::text))
);


ALTER TABLE public.events OWNER TO postgres;

--
-- Name: go_to; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.go_to (
    event_id character varying(200) NOT NULL,
    user_id character varying(200) NOT NULL,
    no_tickets integer NOT NULL,
    CONSTRAINT go_to_no_tickets_check CHECK ((no_tickets > 0))
);


ALTER TABLE public.go_to OWNER TO postgres;

--
-- Name: my_order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.my_order (
    order_id character varying(200) DEFAULT concat('a', public.uuid_generate_v4()) NOT NULL,
    user_id character varying(200),
    book_id character varying(200),
    assign_date date DEFAULT (now())::date,
    is_completed boolean DEFAULT false NOT NULL,
    qty smallint DEFAULT 1 NOT NULL,
    CONSTRAINT my_order_qty_check CHECK ((qty >= 1))
);


ALTER TABLE public.my_order OWNER TO postgres;

--
-- Name: rate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rate (
    user_id character varying(200) NOT NULL,
    book_id character varying(200) NOT NULL,
    rate smallint NOT NULL,
    CONSTRAINT rate_rate_check CHECK (((rate >= 0) AND (rate <= 5)))
);


ALTER TABLE public.rate OWNER TO postgres;

--
-- Name: reader; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reader (
    user_id character varying(200) DEFAULT concat('a', public.uuid_generate_v4()) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    username character varying(50) NOT NULL,
    pass character varying(500) NOT NULL,
    birthdate date NOT NULL,
    balance integer DEFAULT 0,
    gender boolean NOT NULL,
    profile_pic text DEFAULT 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png'::text,
    cover text DEFAULT 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg'::text,
    user_type character varying(50) DEFAULT 'reader'::character varying,
    city character varying(50),
    CONSTRAINT reader_balance_check CHECK ((balance >= 0)),
    CONSTRAINT reader_birthdate_check CHECK ((birthdate < (now())::date)),
    CONSTRAINT reader_city_check CHECK (((city)::text <> ''::text)),
    CONSTRAINT reader_first_name_check CHECK ((((first_name)::text ~ '^[a-zA-Z0-9.,-]+$'::text) AND ((first_name)::text <> ''::text))),
    CONSTRAINT reader_last_name_check CHECK ((((last_name)::text ~ '^[a-zA-Z0-9.,-]+$'::text) AND ((last_name)::text <> ''::text))),
    CONSTRAINT reader_pass_check CHECK (((pass)::text <> ''::text)),
    CONSTRAINT reader_username_check CHECK (((username)::text <> ''::text))
);


ALTER TABLE public.reader OWNER TO postgres;

--
-- Name: review; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review (
    review_id character varying(200) DEFAULT concat('a', public.uuid_generate_v4()) NOT NULL,
    user_id character varying(200),
    book_id character varying(200),
    review_content text NOT NULL,
    review_date date DEFAULT (now())::date,
    CONSTRAINT review_review_content_check CHECK ((review_content <> ''::text))
);


ALTER TABLE public.review OWNER TO postgres;

--
-- Name: ttt; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ttt
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ttt OWNER TO postgres;

--
-- Name: tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tag (
    tag_id character varying(50) DEFAULT ('T'::text || nextval('public.ttt'::regclass)) NOT NULL,
    tag_name character varying(50) NOT NULL
);


ALTER TABLE public.tag OWNER TO postgres;

--
-- Name: user_tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_tag (
    user_id character varying(200) NOT NULL,
    tag_id character varying(50) NOT NULL
);


ALTER TABLE public.user_tag OWNER TO postgres;

--
-- Name: writes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.writes (
    author_id character varying(200) NOT NULL,
    book_id character varying(200) NOT NULL
);


ALTER TABLE public.writes OWNER TO postgres;

--
-- Data for Name: blog; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.blog VALUES
	('a570221f8-6d37-4505-ab2c-dcda3823ed80', 'The Best Fantasy Book EVER', 'Imagine trying to study for a test, not only at a regular school, but one for wizards, and also fearing that a monster will petrify you. That’s how Harry Potter feels. The Chamber of Secrets is open, muggle wizards are being petrified, and there’s a mysterious person who might know something about this. Also, could Harry be the descendant of Slytherin? All these thoughts and more are appearing in your mind as you read Harry Potter and the Chamber of Secrets.

This book was written by J.K. Rowling and was published 1998. The synopsis of the plot is that Harry is back at Hogwarts and is again in the crosshairs of evil. With the Chamber of Secrets, known to be a legend in itself, open, muggle wizards are in a petrified state. Now it is up to Harry, Ron, and Hermione to save the school once again from a certain evil. When I was reading this book it was like a roller coaster of surprises that would leave anyone with a gaping mouth from a shocking twist. The characters are mostly the same as we have seen them. With Harry, being what seems to be on the outside an average boy, but as the book says “Harry Potter wasn’t a normal boy. As a matter of fact, he was not normal as it is possible to be.”', '2022-12-17', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'abc1faf97-ff30-4a1a-bf5d-578696825258'),
	('ac68da7d3-ef45-4e5f-b28e-8389149fe446', 'Harry Potter and the Goblet of Fire and What I wished', 'CONSTANT VIGILANCE From a Behind-the-Scenes documentary found on the DVD Extras, we hear Moody say his famous “Constant Vigilance” line. This scene is also found in the script where it is extended. After asking about the Unforgivable Curses, Moody reveals that he has done background checks on the entire class. He calls Hermione out for being top of the class, naturally inquisitive, socially inept and Muggle born.', '2022-12-12', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aff44ed70-623b-465f-a2d9-d01161c29eba'),
	('ad818b1b2-6ee0-4970-abc5-a7c4cef23e10', 'Someone make this a 1000-page fan fiction please', 'Imagine a Gryffindor and a Slytherin who both embody every stereotype of their house. They end up getting paired together in potions class, and they abhor one another. They fight over everything and end up getting into a fight one lesson, and after the Slytherin hexes the Gryffindor, the latter dunks the former’s head into the cauldron. Snape gives them both detention for a week, and on the second night he has to leave early, but he threatens them if they misbehave. Both students are slightly scared of the professor, so they continue scrubbing the classroom floors.', '2022-12-14', 'a83636a7e-4e55-4db3-bd04-0ea2032f557a', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26'),
	('a1f4b79b0-fd3a-4b7a-9b51-6a42104b42f1', 'Harry Potter and the Order of the Phoenix, the dark side', 'If there was only one thing I was allowed to say about this novel, it would be this: "I hate Delores Umbridge!!!" a sentiment, I know, is shared by many, if not all, Potterheads.
Unlike the first four novels in this enticing series, I was less familiar with the many events that take place in this fifth installment, as it’s the longest book and also the worst movie, in my opinion. The movie itself was excessively choppy and off-kilter, as far as I’m concerned, so I didn’t watch it as much as the first four movies. But, where the movie is stifling and inconsistent, the novel contains in-depth detail and really brings home the many atrocities and difficulties that Harry and his true friends face during their fifth year at Hogwarts, and re-reading this novel has given me a new appreciation for the storyline that the movie so vastly failed to portray.', '2022-10-14', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a448f1202-a573-4817-a201-12442c695ef1'),
	('a4679c4d9-7eeb-4285-8869-94d74d921d4b', 'World', 'Hello', '2022-12-17', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a448f1202-a573-4817-a201-12442c695ef1');


--
-- Data for Name: book; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.book VALUES
	('ad94b33ea-34b9-4cad-a5d8-383b18eccc26', 170, 'Harry Potter and the Philosopher Stone', '1997-06-26', 17, NULL, 1, 5, 9, true, false, 'The first adventure in the spellbinding Harry Potter saga – the series that changed the world of books forever Harry Potter has never even heard of Hogwarts when the letters start dropping on the doormat at number four, Privet Drive. Addressed in green ink on yellowish parchment with a purple seal, they are swiftly confiscated by his grisly aunt and uncle. Then, on Harry’s eleventh birthday, a great beetle-eyed giant of a man called Rubeus Hagrid bursts in with some astonishing news: Harry Potter is a wizard, and he has a place at Hogwarts School of Witchcraft and Wizardry. An incredible adventure is about to begin! These classic editions of J.K. Rowling’s internationally bestselling, multi-award-winning series feature thrilling jackets by Jonny Duddle, bringing Harry Potter to the next generation of young readers.time to PASS THE MAGIC ON', 'https://catalogue.immateriel.fr/resources/dd/e5/8b4eb256331805a7ba3bf4f18c182d253197d4d97853c0ef3347911b6340.jpg'),
	('aff44ed70-623b-465f-a2d9-d01161c29eba', 150, 'Harry Potter and the Goblet of Fire', '2000-07-08', 37, 'Harry Potter and the Prisoner of Azkaban', 4, 5, 11, true, false, 'The fourth adventure in the spellbinding Harry Potter saga – the series that changed the world of books forever The Triwizard Tournament is to be held at Hogwarts. Only wizards who are over seventeen are allowed to enter – but that doesn’t stop Harry dreaming that he will win the competition. Then at Hallowe’en, when the Goblet of Fire makes its selection, Harry is amazed to find his name is one of those that the magical cup picks out. He will face death-defying tasks, dragons and Dark wizards, but with the help of his best friends, Ron and Hermione, he might just make it through – alive! These classic editions of J.K. Rowling’s internationally bestselling, multi-award-winning series feature thrilling jackets by Jonny Duddle, bringing Harry Potter to the next generation of young readers. Its time to PASS THE MAGIC ON', 'https://m.media-amazon.com/images/I/71Ih2rWClAL.jpg'),
	('a448f1202-a573-4817-a201-12442c695ef1', 140, 'Harry Potter And The Order Of The Phoenix', '2003-06-21', 38, 'Harry Potter and the Goblet of Fire', 5, 5, 8, true, false, 'The fifth adventure in the spellbinding Harry Potter saga – the series that changed the world of books forever Dark times have come to Hogwarts. After the Dementors’ attack on his cousin Dudley, Harry Potter knows that Voldemort will stop at nothing to find him. There are many who deny the Dark Lord’s return, but Harry is not alone: a secret order gathers at Grimmauld Place to fight against the Dark forces. Harry must allow Professor Snape to teach him how to protect himself from Voldemort’s savage assaults on his mind. But they are growing stronger by the day and Harry is running out of time. These classic editions of J.K. Rowling’s internationally bestselling, multi-award-winning series feature thrilling jackets by Jonny Duddle, bringing Harry Potter to the next generation of young readers. Its time to PASS THE MAGIC ON', 'https://m.media-amazon.com/images/I/71+TMmKfv9L.jpg'),
	('a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', 590, 'Harry Potter and the Prisoner of Azkaban', '1999-07-08', 22, 'Harry Potter and the Chamber of Secrets', 3, 5, 8, true, false, 'This special edition of HARRY POTTER AND THE PRISONER OF AZKABAN has a gorgeous new cover illustrated by Kazu Kibuishi. Inside is the full text of the original novel, with decorations by Mary GrandPre
For twelve long years, the dread fortress of Azkaban held an infamous prisoner named Sirius Black. Convicted of killing thirteen people with a single curse, he was said to be the heir apparent to the Dark Lord, Voldemort.Now he has escaped, leaving only two clues as to where he might be headed: Harry Potters defeat of You-Know-Who was Blacks downfall as well. And the Azkaban guards heard Black muttering in his sleep, "Hes at Hogwarts... hes at Hogwarts."Harry Potter isnt safe, not even within the walls of his magical school, surrounded by his friends. Because on top of it all, there may be a traitor in their midst.', 'https://m.media-amazon.com/images/I/714hT0XFZpL.jpg'),
	('abc1faf97-ff30-4a1a-bf5d-578696825258', 175, 'Harry Potter and the Chamber of Secrets', '1998-07-02', 18, 'Harry Potter and the Philosopher Stone', 2, 5, 8, true, false, 'The Dursleys were so mean that hideous that summer that all Harry Potter wanted was to get back to the Hogwarts School for Witchcraft and Wizardry. But just as hes packing his bags, Harry receives a warning from a strange, impish creature named Dobby who says that if Harry Potter returns to Hogwarts, disaster will strike.

And strike it does. For in Harrys second year at Hogwarts, fresh torments and horrors arise, including an outrageously stuck-up new professor, Gilderoy Lockheart, a spirit named Moaning Myrtle who haunts the girls bathroom, and the unwanted attentions of Ron Weasleys younger sister, Ginny.

But each of these seem minor annoyances when the real trouble begins, and someone--or something--starts turning Hogwarts students to stone. Could it be Draco Malfoy, a more poisonous rival than ever? Could it possibly be Hagrid, whose mysterious past is finally told? Or could it be the one everyone at Hogwarts most suspects...Harry Potter himself?', 'https://m.media-amazon.com/images/I/91HHqVTAJQL.jpg'),
	('a5bf054bd-1ef9-48bb-9822-89ef233e2672', 230, 'Harry Potter and the Half-Blood Prince', '2005-07-16', 30, 'Harry Potter And The Order Of The Phoenix', 6, 5, 8, true, false, 'This special edition of HARRY POTTER AND THE HALF-BLOOD PRINCE has a gorgeous new cover illustration by Kazu Kibuishi. Inside is the full text of the original novel, with decorations by Mary GrandPré.
The war against Voldemort is not going well; even Muggle governments are noticing. Ron scans the obituary pages of the Daily Prophet, looking for familiar names. Dumbledore is absent from Hogwarts for long stretches of time, and the Order of the Phoenix has already suffered losses. And yet...As in all wars, life goes on. Sixth-year students learn to Apparate - and lose a few eyebrows in the process. The Weasley twins expand their business. Teenagers flirt and fight and fall in love. Classes are never straightforward, though Harry receives some extraordinary help from the mysterious Half-Blood Prince.So its the home front that takes center stage in the multilayered sixth installment of the story of Harry Potter. Here at Hogwarts, Harry will search for the full and complex story of the boy who became Lord Voldemort - and thereby find what may be his only vulnerability.', 'https://m.media-amazon.com/images/I/71HAU27ETJL.jpg'),
	('af60e0930-c4c8-4bea-ba38-e5723cdfe8d4', 240, 'Harry Potter and the Deathly Hallows', '2007-07-21', 37, 'Harry Potter and the Half-Blood Prince', 7, 5, 8, true, false, 'Readers beware. The brilliant, breathtaking conclusion to J.K. Rowlings spellbinding series is not for the faint of heart--such revelations, battles, and betrayals await in Harry Potter and the Deathly Hallows that no fan will make it to the end unscathed. Luckily, Rowling has prepped loyal readers for the end of her series by doling out increasingly dark and dangerous tales of magic and mystery, shot through with lessons about honor and contempt, love and loss, and right and wrong. Fear not, you will find no spoilers in our review--to tell the plot would ruin the journey, and Harry Potter and the Deathly Hallows is an odyssey the likes of which Rowlings fans have not yet seen, and are not likely to forget. But we would be remiss if we did not offer one small suggestion before you embark on your final adventure with Harry--bring plenty of tissues.
The heart of Book 7 is a heros mission--not just in Harrys quest for the Horcruxes, but in his journey from boy to man--and Harry faces more danger than that found in all six books combined, from the direct threat of the Death Eaters and you-know-who, to the subtle perils of losing faith in himself. Attentive readers would do well to remember Dumbledores warning about making the choice between "what is right and what is easy," and know that Rowling applies the same difficult principle to the conclusion of her series. While fans will find the answers to hotly speculated questions about Dumbledore, Snape, and you-know-who, it is a testament to Rowlings skill as a storyteller that even the most astute and careful reader will be taken by surprise.

A spectacular finish to a phenomenal series, Harry Potter and the Deathly Hallows is a bittersweet read for fans. The journey is hard, filled with events both tragic and triumphant, the battlefield littered with the bodies of the dearest and despised, but the final chapter is as brilliant and blinding as a phoenixs flame, and fans and skeptics alike will emerge from the confines of the story with full but heavy hearts, giddy and grateful for the experience.', 'https://m.media-amazon.com/images/I/71sH3vxziLL.jpg'),
	('a18eac441-660b-44d5-89e7-b8d918690545', 320, 'Game of Thrones: A Game of Thrones', '1996-08-01', 73, NULL, 1, 5, 13, true, false, 'Winter is coming. Such is the stern motto of House Stark, the northernmost of the fiefdoms that owe allegiance to King Robert Baratheon in far-off King’s Landing. There Eddard Stark of Winterfell rules in Robert’s name. There his family dwells in peace and comfort: his proud wife, Catelyn; his sons Robb, Brandon, and Rickon; his daughters Sansa and Arya; and his bastard son, Jon Snow. Far to the north, behind the towering Wall, lie savage Wildings and worse—unnatural things relegated to myth during the centuries-long summer, but proving all too real and all too deadly in the turning of the season.
 
Yet a more immediate threat lurks to the south, where Jon Arryn, the Hand of the King, has died under mysterious circumstances. Now Robert is riding north to Winterfell, bringing his queen, the lovely but cold Cersei, his son, the cruel, vainglorious Prince Joffrey, and the queen’s brothers Jaime and Tyrion of the powerful and wealthy House Lannister—the first a swordsman without equal, the second a dwarf whose stunted stature belies a brilliant mind. All are heading for Winterfell and a fateful encounter that will change the course of kingdoms.
 
Meanwhile, across the Narrow Sea, Prince Viserys, heir of the fallen House Targaryen, which once ruled all of Westeros, schemes to reclaim the throne with an army of barbarian Dothraki—whose loyalty he will purchase in the only coin left to him: his beautiful yet innocent sister, Daenerys.', 'https://m.media-amazon.com/images/I/A1MExOEakfL.jpg'),
	('a104d6e47-c5f9-4203-806d-f34110985b98', 400, 'Game of Thrones: A Clash of Kings', '1998-11-16', 70, 'Game of Thrones: A Game of Thrones', 2, 5, 16, true, false, 'In this eagerly awaited sequel to A Game of Thrones, George R. R. Martin has created a work of unsurpassed vision, power, and imagination. A Clash of Kings transports us to a world of revelry and revenge, wizardry and warfare unlike any you have ever experienced.

A CLASH OF KINGS

A comet the color of blood and flame cuts across the sky. And from the ancient citadel of Dragonstone to the forbidding shores of Winterfell, chaos reigns. Six factions struggle for control of a divided land and the Iron Throne of the Seven Kingdoms, preparing to stake their claims through tempest, turmoil, and war. It is a tale in which brother plots against brother and the dead rise to walk in the night. Here a princess masquerades as an orphan boy; a knight of the mind prepares a poison for a treacherous sorceress; and wild men descend from the Mountains of the Moon to ravage the countryside. Against a backdrop of incest and fratricide, alchemy and murder, victory may go to the men and women possessed of the coldest steel...and the coldest hearts. For when kings clash, the whole land trembles.', 'https://m.media-amazon.com/images/I/91Nl6NuijHL.jpg'),
	('a964791fc-da74-4fc3-829b-a7dd08badcf5', 400, 'Game of Thrones: A Storm of Swords', '2000-08-08', 82, 'Game of Thrones: A Clash of Kings', 3, 5, 17, true, false, 'Here is the third volume in George R. R. Martin’s magnificent cycle of novels that includes A Game of Thrones and A Clash of Kings. As a whole, this series comprises a genuine masterpiece of modern fantasy, bringing together the best the genre has to offer. Magic, mystery, intrigue, romance, and adventure fill these pages and transport us to a world unlike any we have ever experienced. Already hailed as a classic, George R. R. Martin’s stunning series is destined to stand as one of the great achievements of imaginative fiction.

A STORM OF SWORDS

Of the five contenders for power, one is dead, another in disfavor, and still the wars rage as violently as ever, as alliances are made and broken. Joffrey, of House Lannister, sits on the Iron Throne, the uneasy ruler of the land of the Seven Kingdoms. His most bitter rival, Lord Stannis, stands defeated and disgraced, the victim of the jealous sorceress who holds him in her evil thrall. But young Robb, of House Stark, still rules the North from the fortress of Riverrun. Robb plots against his despised Lannister enemies, even as they hold his sister hostage at King’s Landing, the seat of the Iron Throne. Meanwhile, making her way across a blood-drenched continent is the exiled queen, Daenerys, mistress of the only three dragons still left in the world. . . .

But as opposing forces maneuver for the final titanic showdown, an army of barbaric wildlings arrives from the outermost line of civilization. In their vanguard is a horde of mythical Others—a supernatural army of the living dead whose animated corpses are unstoppable. As the future of the land hangs in the balance, no one will rest until the Seven Kingdoms have exploded in a veritable storm of swords', 'https://m.media-amazon.com/images/I/91d-77kn-dL.jpg'),
	('a2c6d5466-b154-47b1-b23b-63a73ec9f76c', 400, 'Game of Thrones: A Feast for Crows', '2005-10-17', 46, 'Game of Thrones: A Storm of Swords', 4, 5, 18, true, false, 'Few books have captivated the imagination and won the devotion and praise of readers and critics everywhere as has George R. R. Martin’s monumental epic cycle of high fantasy. Now, in A Feast for Crows, Martin delivers the long-awaited fourth book of his landmark series, as a kingdom torn asunder finds itself at last on the brink of peace . . . only to be launched on an even more terrifying course of destruction.

A FEAST FOR CROWS

It seems too good to be true. After centuries of bitter strife and fatal treachery, the seven powers dividing the land have decimated one another into an uneasy truce. Or so it appears. . . . With the death of the monstrous King Joffrey, Cersei is ruling as regent in King’s Landing. Robb Stark’s demise has broken the back of the Northern rebels, and his siblings are scattered throughout the kingdom like seeds on barren soil. Few legitimate claims to the once desperately sought Iron Throne still exist—or they are held in hands too weak or too distant to wield them effectively. The war, which raged out of control for so long, has burned itself out.

But as in the aftermath of any climactic struggle, it is not long before the survivors, outlaws, renegades, and carrion eaters start to gather, picking over the bones of the dead and fighting for the spoils of the soon-to-be dead. Now in the Seven Kingdoms, as the human crows assemble over a banquet of ashes, daring new plots and dangerous new alliances are formed, while surprising faces—some familiar, others only just appearing—are seen emerging from an ominous twilight of past struggles and chaos to take up the challenges ahead.

It is a time when the wise and the ambitious, the deceitful and the strong will acquire the skills, the power, and the magic to survive the stark and terrible times that lie before them. It is a time for nobles and commoners, soldiers and sorcerers, assassins and sages to come together and stake their fortunes . . . and their lives. For at a feast for crows, many are the guests—but only a few are the survivors.', 'https://m.media-amazon.com/images/I/81MylCMYnVL.jpg'),
	('aee18d3bb-b473-454f-a429-4ef9d85d4275', 400, 'Game of Thrones: A Dance with Dragons', '2011-07-12', 73, 'Game of Thrones: A Feast for Crows', 5, 5, 18, true, false, 'Dubbed “the American Tolkien” by Time magazine, George R. R. Martin has earned international acclaim for his monumental cycle of epic fantasy. Now the #1 New York Times bestselling author delivers the fifth book in his landmark series—as both familiar faces and surprising new forces vie for a foothold in a fragmented empire.

A DANCE WITH DRAGONS

In the aftermath of a colossal battle, the future of the Seven Kingdoms hangs in the balance—beset by newly emerging threats from every direction. In the east, Daenerys Targaryen, the last scion of House Targaryen, rules with her three dragons as queen of a city built on dust and death. But Daenerys has thousands of enemies, and many have set out to find her. As they gather, one young man embarks upon his own quest for the queen, with an entirely different goal in mind.

Fleeing from Westeros with a price on his head, Tyrion Lannister, too, is making his way to Daenerys. But his newest allies in this quest are not the rag-tag band they seem, and at their heart lies one who could undo Daenerys’s claim to Westeros forever.

Meanwhile, to the north lies the mammoth Wall of ice and stone—a structure only as strong as those guarding it. There, Jon Snow, 998th Lord Commander of the Night’s Watch, will face his greatest challenge. For he has powerful foes not only within the Watch but also beyond, in the land of the creatures of ice.

From all corners, bitter conflicts reignite, intimate betrayals are perpetrated, and a grand cast of outlaws and priests, soldiers and skinchangers, nobles and slaves, will face seemingly insurmountable obstacles. Some will fail, others will grow in the strength of darkness. But in a time of rising restlessness, the tides of destiny and politics will lead inevitably to the greatest dance of all.', 'https://m.media-amazon.com/images/I/81e1rZDeBBL.jpg');


--
-- Data for Name: book_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.book_tag VALUES
	('abc1faf97-ff30-4a1a-bf5d-578696825258', 'T1001'),
	('ad94b33ea-34b9-4cad-a5d8-383b18eccc26', 'T1001'),
	('a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', 'T1001'),
	('a964791fc-da74-4fc3-829b-a7dd08badcf5', 'T1029'),
	('a964791fc-da74-4fc3-829b-a7dd08badcf5', 'T1001'),
	('a18eac441-660b-44d5-89e7-b8d918690545', 'T1029'),
	('a18eac441-660b-44d5-89e7-b8d918690545', 'T1001'),
	('a2c6d5466-b154-47b1-b23b-63a73ec9f76c', 'T1029'),
	('a2c6d5466-b154-47b1-b23b-63a73ec9f76c', 'T1001'),
	('aee18d3bb-b473-454f-a429-4ef9d85d4275', 'T1029'),
	('aee18d3bb-b473-454f-a429-4ef9d85d4275', 'T1001'),
	('a104d6e47-c5f9-4203-806d-f34110985b98', 'T1029'),
	('a104d6e47-c5f9-4203-806d-f34110985b98', 'T1001'),
	('a448f1202-a573-4817-a201-12442c695ef1', 'T1004'),
	('af60e0930-c4c8-4bea-ba38-e5723cdfe8d4', 'T1004'),
	('a5bf054bd-1ef9-48bb-9822-89ef233e2672', 'T1004'),
	('aff44ed70-623b-465f-a2d9-d01161c29eba', 'T1004'),
	('a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', 'T1004'),
	('ad94b33ea-34b9-4cad-a5d8-383b18eccc26', 'T1004');


--
-- Data for Name: borrow; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.borrow VALUES
	('a83636a7e-4e55-4db3-bd04-0ea2032f557a', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-08-05', true),
	('a83636a7e-4e55-4db3-bd04-0ea2032f557a', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-24', false);


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.events VALUES
	('a57c7ba28-8061-4ab4-ae7b-89d79eb36ea9', 'Pyramids,Giza,Egypt', 500, 1000, 'J. K. Rowling Signing Books!!', '2022-12-31', 'The amazing author of the Harry Potter series is coming to Egypt to make a great festival and sign books for fans.', 'https://media.discordapp.net/attachments/916775831064424478/1053701343694573688/pexels-caleb-oquendo-3023317.jpg?width=994&height=663');


--
-- Data for Name: go_to; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.go_to VALUES
	('a57c7ba28-8061-4ab4-ae7b-89d79eb36ea9', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 5),
	('a57c7ba28-8061-4ab4-ae7b-89d79eb36ea9', 'a83636a7e-4e55-4db3-bd04-0ea2032f557a', 2),
	('a57c7ba28-8061-4ab4-ae7b-89d79eb36ea9', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 3);


--
-- Data for Name: my_order; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.my_order VALUES
	('ab8e86b42-cc5e-4f4c-9878-18d8cce4c0b4', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'abc1faf97-ff30-4a1a-bf5d-578696825258', '2022-12-17', true, 3),
	('aa0f5fe73-708e-4c4f-b31a-8c3f127c1b1d', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 1),
	('a32127104-b2f3-4db6-8d8e-ceae69a53665', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 2),
	('a647a2a2f-6f79-4cc1-bf3a-f4b1f5a9cffd', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 6),
	('a30030011-7b7a-405b-a1f2-4b116380511c', 'a06dd3e9b-e999-43e1-99bd-d0314f7e381f', 'af60e0930-c4c8-4bea-ba38-e5723cdfe8d4', '2023-09-25', false, 1),
	('a265ae60e-5f80-4301-bfff-ecb582d21426', 'a06dd3e9b-e999-43e1-99bd-d0314f7e381f', 'a18eac441-660b-44d5-89e7-b8d918690545', '2023-09-25', false, 1),
	('a2152d98e-356d-4181-b81e-ab24c5298c6d', 'a06dd3e9b-e999-43e1-99bd-d0314f7e381f', 'aee18d3bb-b473-454f-a429-4ef9d85d4275', '2023-09-25', false, 1);


--
-- Data for Name: rate; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rate VALUES
	('a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', 4),
	('a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', 5),
	('a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a18eac441-660b-44d5-89e7-b8d918690545', 3),
	('a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a18eac441-660b-44d5-89e7-b8d918690545', 4),
	('a83636a7e-4e55-4db3-bd04-0ea2032f557a', 'a18eac441-660b-44d5-89e7-b8d918690545', 1),
	('a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', 3);


--
-- Data for Name: reader; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.reader VALUES
	('a06dd3e9b-e999-43e1-99bd-d0314f7e381f', 'mohamed', 'atef', 'Mohamed', '$2b$12$CdoZ030miuSFvxmXttfYb.8zHRFNwVyyRkGVtgJHaPJ00/7AzvOXW', '2002-08-30', 200, true, 'https://i.ibb.co/n6D6kG7/Cam-Scanner-06-30-2022-19-00-1.jpg', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'Reader', 'Giza'),
	('a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'Marwan', 'Samy', 'MarwanKun', '$2b$12$PQ6IjDTdT0l8ThttcghqDehW0V3Rrvmuz2ySMum3ibW5s.AEt2LMe', '2002-07-19', 500200, true, '${pic}', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'reader', 'Giza'),
	('a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'Seif', 'Hany', 'Sofa5060', '$2b$12$hD1090ELWOcJhXnlEmCHAOPL0EZuXvqu9vkAex1UkVHYbNo7pI/pm', '2002-10-01', 500200, true, '${pic}', '${cover}', 'reader', 'Cairo'),
	('a83636a7e-4e55-4db3-bd04-0ea2032f557a', 'Mohamed', 'Atef', '-Ghost-', '$2b$12$pNRKnLPh1MUsKden/udqW.6jUCvoYYWIwjGGchN.TFNyFGYNtd3/a', '2002-08-30', 500200, true, 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'reader', 'Giza'),
	('aed7653f6-2930-4a8f-aeee-a516ed91df7a', 'Marwan', 'Emad', 'Scorpion', '$2b$12$a7mhQVjoYioIoddnaJHMEOwjoJoNz2gn3li.2e3//ZpmheU.Esamy', '2002-01-01', 500200, true, 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'admin', 'Cairo'),
	('af0cd7987-4b09-4763-a810-c4649d868f78', 'George', 'Raymond', 'George R. R. Martin', '$2b$12$/X7IEYSfibhCdQFxKXM0E.V/JMfk9SLpethsubPSBxa1AEuP372fK', '1948-09-20', 500200, true, 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/George_R.R._Martin_at_Archipelacon.jpg/800px-George_R.R._Martin_at_Archipelacon.jpg', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'author', 'New Jersy'),
	('a62a6d457-4e7b-4d4f-a830-11c0884344c2', 'Joanne', 'Rowling', 'J. K. Rowling', '$2b$12$nYuYvFPTiBwqt7vS4ouw4eeFH9YLYuBdmPy2jVN/DGqDPNYcFjLeG', '1965-07-31', 500200, false, 'https://www.biography.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTc5OTUwMTA3MzE4Mjk3OTQ0/gettyimages-1061157246.jpg', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'author', 'London');


--
-- Data for Name: review; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.review VALUES
	('a27166da4-7440-45ab-91f3-c693f420342b', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'abc1faf97-ff30-4a1a-bf5d-578696825258', 'I hope to buy this book soon I cant wait', '2022-10-20'),
	('aa88431ce-bf41-4b43-9c32-a40fa84de820', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', 'ya rab', '2022-12-18'),
	('a7da26534-4066-444f-bd28-dbea3a1c1f62', 'af0cd7987-4b09-4763-a810-c4649d868f78', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', 'WTF', '2022-12-18');


--
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tag VALUES
	('T1001', 'Fantasy'),
	('T1002', 'Fiction'),
	('T1003', 'Nonfiction'),
	('T1004', 'Adventure'),
	('T1005', 'Romance'),
	('T1006', 'Contemporary'),
	('T1007', 'Dystopian'),
	('T1008', 'Mystery'),
	('T1009', 'Horror'),
	('T1010', 'Thriller'),
	('T1011', 'Paranormal'),
	('T1012', 'Historical Fiction'),
	('T1013', 'Science Fiction'),
	('T1014', 'Children'),
	('T1015', 'Memoir'),
	('T1016', 'Cookbook'),
	('T1017', 'Art'),
	('T1018', 'Self Help'),
	('T1019', 'Development'),
	('T1020', 'Motivational'),
	('T1021', 'Health'),
	('T1022', 'History'),
	('T1023', 'Travel'),
	('T1024', 'Guide'),
	('T1025', 'Families'),
	('T1026', 'Relationships'),
	('T1027', 'Humor'),
	('T1028', 'Western'),
	('T1029', 'Novel');


--
-- Data for Name: user_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_tag VALUES
	('a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'T1003'),
	('a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'T1010'),
	('a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'T1019'),
	('a62a6d457-4e7b-4d4f-a830-11c0884344c2', 'T1001'),
	('a83636a7e-4e55-4db3-bd04-0ea2032f557a', 'T1005'),
	('a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'T1009');


--
-- Data for Name: writes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.writes VALUES
	('a62a6d457-4e7b-4d4f-a830-11c0884344c2', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50'),
	('a62a6d457-4e7b-4d4f-a830-11c0884344c2', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26'),
	('a62a6d457-4e7b-4d4f-a830-11c0884344c2', 'abc1faf97-ff30-4a1a-bf5d-578696825258'),
	('a62a6d457-4e7b-4d4f-a830-11c0884344c2', 'aff44ed70-623b-465f-a2d9-d01161c29eba'),
	('a62a6d457-4e7b-4d4f-a830-11c0884344c2', 'a448f1202-a573-4817-a201-12442c695ef1'),
	('a62a6d457-4e7b-4d4f-a830-11c0884344c2', 'a5bf054bd-1ef9-48bb-9822-89ef233e2672'),
	('a62a6d457-4e7b-4d4f-a830-11c0884344c2', 'af60e0930-c4c8-4bea-ba38-e5723cdfe8d4'),
	('af0cd7987-4b09-4763-a810-c4649d868f78', 'a104d6e47-c5f9-4203-806d-f34110985b98'),
	('af0cd7987-4b09-4763-a810-c4649d868f78', 'aee18d3bb-b473-454f-a429-4ef9d85d4275'),
	('af0cd7987-4b09-4763-a810-c4649d868f78', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c'),
	('af0cd7987-4b09-4763-a810-c4649d868f78', 'a18eac441-660b-44d5-89e7-b8d918690545'),
	('af0cd7987-4b09-4763-a810-c4649d868f78', 'a964791fc-da74-4fc3-829b-a7dd08badcf5');


--
-- Name: ttt; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ttt', 1029, true);


--
-- Name: blog blog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog
    ADD CONSTRAINT blog_pkey PRIMARY KEY (blog_id);


--
-- Name: book book_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT book_pkey PRIMARY KEY (book_id);


--
-- Name: book_tag book_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_tag
    ADD CONSTRAINT book_tag_pkey PRIMARY KEY (book_id, tag_id);


--
-- Name: book book_title_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT book_title_key UNIQUE (title);


--
-- Name: borrow borrow_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrow
    ADD CONSTRAINT borrow_pkey PRIMARY KEY (book_id, user_id, return_date);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (event_id);


--
-- Name: go_to go_to_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.go_to
    ADD CONSTRAINT go_to_pkey PRIMARY KEY (event_id, user_id);


--
-- Name: my_order my_order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.my_order
    ADD CONSTRAINT my_order_pkey PRIMARY KEY (order_id);


--
-- Name: rate rate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rate
    ADD CONSTRAINT rate_pkey PRIMARY KEY (user_id, book_id);


--
-- Name: reader reader_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reader
    ADD CONSTRAINT reader_pkey PRIMARY KEY (user_id);


--
-- Name: reader reader_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reader
    ADD CONSTRAINT reader_username_key UNIQUE (username);


--
-- Name: review review_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_pkey PRIMARY KEY (review_id);


--
-- Name: tag tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (tag_id);


--
-- Name: tag tag_tag_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_tag_name_key UNIQUE (tag_name);


--
-- Name: user_tag user_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tag
    ADD CONSTRAINT user_tag_pkey PRIMARY KEY (user_id, tag_id);


--
-- Name: writes writes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.writes
    ADD CONSTRAINT writes_pkey PRIMARY KEY (author_id, book_id);


--
-- Name: blog blog_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog
    ADD CONSTRAINT blog_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(book_id) ON DELETE CASCADE;


--
-- Name: blog blog_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog
    ADD CONSTRAINT blog_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.reader(user_id) ON DELETE CASCADE;


--
-- Name: book_tag book_tag_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_tag
    ADD CONSTRAINT book_tag_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(book_id) ON DELETE CASCADE;


--
-- Name: book_tag book_tag_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_tag
    ADD CONSTRAINT book_tag_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tag(tag_id);


--
-- Name: borrow borrow_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrow
    ADD CONSTRAINT borrow_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(book_id) ON DELETE CASCADE;


--
-- Name: borrow borrow_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrow
    ADD CONSTRAINT borrow_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.reader(user_id) ON DELETE CASCADE;


--
-- Name: go_to go_to_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.go_to
    ADD CONSTRAINT go_to_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id) ON DELETE CASCADE;


--
-- Name: go_to go_to_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.go_to
    ADD CONSTRAINT go_to_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.reader(user_id) ON DELETE CASCADE;


--
-- Name: my_order my_order_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.my_order
    ADD CONSTRAINT my_order_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(book_id) ON DELETE SET NULL;


--
-- Name: my_order my_order_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.my_order
    ADD CONSTRAINT my_order_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.reader(user_id) ON DELETE SET NULL;


--
-- Name: rate rate_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rate
    ADD CONSTRAINT rate_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(book_id) ON DELETE CASCADE;


--
-- Name: rate rate_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rate
    ADD CONSTRAINT rate_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.reader(user_id) ON DELETE CASCADE;


--
-- Name: review review_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(book_id) ON DELETE CASCADE;


--
-- Name: review review_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.reader(user_id) ON DELETE CASCADE;


--
-- Name: user_tag user_tag_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tag
    ADD CONSTRAINT user_tag_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tag(tag_id) ON DELETE CASCADE;


--
-- Name: user_tag user_tag_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tag
    ADD CONSTRAINT user_tag_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.reader(user_id) ON DELETE CASCADE;


--
-- Name: writes writes_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.writes
    ADD CONSTRAINT writes_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.reader(user_id) ON DELETE CASCADE;


--
-- Name: writes writes_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.writes
    ADD CONSTRAINT writes_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(book_id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

