/*
  This is an example SQL for linking an initial Users table to a related table of Hikes stored by Users
  
  Demonstrates how a MySQL table links to another table to begin building a web app.
  
  Other tables could be linked from these existing tables, or rebuilt to model different data requirements.
  
  >>> EDIT: Replace xx_ with your table prefix!

  Bill Newman, Updated: 02/28/2020
  https://github.com/newmanix/example-mysql-link-tables
  
  https://www.apache.org/licenses/LICENSE-2.0
  
  Here are a few notes on things below that may not be self evident:
  
  INDEXES: You'll see indexes below for example:
  
  INDEX `UserID` (`UserID`)
  
  Any field that has highly unique data that is either searched on or used as a join should be indexed, which speeds up a  
  search on a tall table, but potentially slows down an add or delete
  
  TIMESTAMP: MySQL currently only supports one date field per table to be automatically updated with the current time.  We'll use a 
  field in a few of the tables named LastUpdated:
  
  LastUpdated TIMESTAMP DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP
  
  The other date oriented field we are interested in, DateAdded we'll do by hand on insert with the MySQL function NOW().
  
  CASCADES: In order to avoid orphaned records in deletion of a User, we'll want to get rid of the associated Hike data, etc. 
  We therefore want a 'cascading delete' in which the deletion of a User activates a 'cascade' of deletions in an 
  associated table.  Here's what the syntax looks like:  
  
  CONSTRAINT `UserID_Hikes_fk` FOREIGN KEY (`UserID`) REFERENCES `xx_Users` (`UserID`) ON DELETE CASCADE
  
  The above is from the Hikes table, which stores a foreign key, UserID in it.  This line of code tags the foreign key to 
  identify which associated records to delete.
  
  Be sure to check your cascades by deleting a User and watch all the related table data disappear!
  
  Here are a couple of useful SQL calls for your app:
    
  #all user hikes (3)
  select * from xx_Hikes
  
  #first user's hikes (2)
  select * from xx_Hikes where UserID = 1

*/


SET foreign_key_checks = 0;

#drop tables in reverse order, moving from branch to root
DROP TABLE IF EXISTS `xx_Hikes`;
DROP TABLE IF EXISTS `xx_Users`;

CREATE TABLE `xx_Users` (
  `UserID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `LastName` varchar(50) DEFAULT '',
  `FirstName` varchar(50) DEFAULT '',
  `Email` varchar(120) DEFAULT '',
  `Bio` text,
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `xx_Users` (`UserID`, `LastName`, `FirstName`, `Email`, `Bio`) VALUES
(1,	'Wilson',	'Russell',	'rw@example.com',	'Born on November 29, 1988, in Cincinnati, Ohio, Russell Wilson was a multi-sport star in high school. ... Nevertheless, Wilson quickly became an elite pro quarterback, and led the Seattle Seahawks to a Super Bowl victory in just his second season.'),
(2,	'Loyd',	'Jewell',	'jl@example.com',	'Jewell Loyd (born October 5, 1993) is an American professional basketball player for Perfumerias Avenida of Spain\'s Liga Femenina de Baloncesto and the Seattle Storm of the Women\'s National Basketball Association (WNBA). She was drafted first overall in the 2015 WNBA Draft by the Seattle Storm.'),
(3,	'Ruidiaz',	'Raul',	'rr@example.com',	'Raul Ruidiaz (born 25 July 1990) is a Peruvian footballer who currently plays for Seattle Sounders FC and the Peru national team, as a striker.\r\n\r\nHis nickname, \"The Flea\", stems from his small frame and his ability to get past defenders with great ball control.');

#foreign key field must match size and type, hence UserID is INT UNSIGNED
CREATE TABLE `xx_Hikes` (
  `HikeID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `UserID` int(10) unsigned DEFAULT '0',
  `HikeName` varchar(255) DEFAULT '',
  `Location` varchar(255) DEFAULT '',
  `Gain` smallint(6) DEFAULT '0',
  `HighestPoint` smallint(6) DEFAULT '0',
  `Length` float DEFAULT '0',
  `Rating` tinyint(4) DEFAULT '0',
  `Difficulty` tinyint(4) DEFAULT '0',
  `Description` text,
  `Directions` text,
  `DateAdded` datetime DEFAULT NULL,
  `LastUpdated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`HikeID`),
  INDEX `UserID` (`UserID`),
  CONSTRAINT `UserID_Hikes_fk` FOREIGN KEY (`UserID`) REFERENCES `xx_Users` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `xx_Hikes` (`HikeID`, `UserID`, `HikeName`, `Location`, `Gain`, `HighestPoint`, `Length`, `Rating`, `Difficulty`, `Description`, `Directions`, `DateAdded`, `LastUpdated`) VALUES
(1,	1,	'Iron Bear - Teanaway Ridge',	'Snoqualmie Region -- Salmon La Sac/Teanaway',	1900,	5489,	6.5,	5,	2,	'This is an ideal trail to enjoy abundant wildflowers and mountain views in May or June when the weather on the west side of the Cascades is dreary. Simply cross the pass to find it sunny and warm on the east side.\r\n\r\nSpringtime is such a popular season for hiking this trail that the US Forest Service closes it to motorized use from April 1 through Jun 15 each year. If you\'re hiking from October to April, visit on a weekday if you\'d like to avoid encounters with motor vehicles.\r\n\r\nThe Iron Bear Trail starts in forest, then proceeds through low shrubs, including serviceberry and snowbrush. In spring, there are many wildflowers, such as balsamroot, penstemon, paintbrush, and forget-me-nots along the trail. If you are a wildflower fan, you will recognize a lot more species.\r\n\r\nWith so many flowers and great mountain views, this is certainly one of the most beautiful hiking trails around.',	'From I-90 take exit 85. Go left to cross the freeway, and make a right onto 970, passing the Twin Pines Drive-In. Hwy 970 veers left. 9.4 miles past the Twin Pines Drive-In, turn left onto Hwy 97 and continue for 9.9 miles.\r\n\r\nTurn left onto FR 9714 for 2.7 miles to the end at the trailhead for Trail 1351. At the end of FR 9714 you will ford a stream just before you get to the trailhead. The last 200 yards of road is a bit dicey but you can park in several turnouts just before you get to the ford.\r\n\r\nThe Iron Creek trailhead is three miles from Hwy 97. No fee is required to park there, but there is no toilet available this trailhead.',	NULL,	'2020-02-28 15:13:30'),
(2,	2,	'Rattlesnake Lake',	'Snoqualmie Region -- North Bend Area',	300,	1900,	11,	3,	2,	'Formerly known as the John Wayne Trail, the Palouse to Cascades Trail in Iron Horse State Park provides access to notable North Bend hikes, views of mountains and waterfalls, and a journey back into Washington’s history. Take in the wildlife and cross soaring bridges as you make a level traverse from Rattlesnake Lake to Change and Hall Creeks 5.5 miles to the east.\r\n\r\nThe trail is lined by bigleaf maple, alder, western hemlock, Douglas fir, salmonberry, and thimbleberry. Falls colors can be spectacular. Squirrel and chipmunks squeak at you, and bald eagles and red-tailed hawks may circle overhead.\r\n\r\nAt 1 mile, cross over Boxley Creek with its outflow measuring station and pass the Cedar Butte trailhead on the right. Continue onward under the canopy, passing the falls of Boetzke Creek and then the abandoned train depot of Ragnar about 1 mile later. The trail still has the railroad’s mileposts, and many railroad artifacts are at Ragnar. Please feel free to enjoy these and take photographs, but leave them in place for other hikers to appreciate after you.\r\n\r\nAt 4.5 miles, pass the eastern terminus of the Twin Falls trail, on the left. Just 0.5 miles later, the unmarked trail to Mount Washington dips briefly between two large alders and begins its brutal ascent.\r\n\r\nAt 5.5 miles, reach the first of two towering trestles over Change and Hall Creeks. These former railroad bridges offer unsurpassed views of West Defiance Ridge, to the north, and Deception Crags, sheer rock walls used by climbers, lying to your south.',	'From Seattle, proceed east on I-90. Take exit 32, making a right on 434th Ave, which becomes Cedar Falls Road SE. Pass the Rattlesnake Lake parking area, coming to the entrance and parking area for Iron Horse State Park 3.0 miles from exit 32. The entrance will be on your left. There are 63 parking spots, including 2 for ADA access and 5 for trailers. There is a privy at the trailhead.',	NULL,	'2020-02-28 15:11:34'),
(3,	1,	'Anderson and Watson Lakes',	'North Cascades -- Mount Baker Area',	1100,	4900,	6,	5,	2,	'This trail features plenty of variety, with destinations spaced perfectly for families or first-time backpackers. Beautiful hemlock forest, meadows dotted with wildflowers, gleaming lakes, mountain views, juicy berries and excellent camping are all available. Wait until later in the hiking season though, as this area is known for its bugs.\r\n\r\nBegin hiking through a beautiful forest of second-growth hemlock. Boardwalks help keep your feet dry and add interest for younger hikers. After approximately a mile of hiking, arrive in a pretty meadow, where you\'ll find a signed junction for Anderson Butte. This 1.5 mile side trip is a steep hike, but well-shaded, and worth the sweat expended to achieve the summit, offering views of Mounts Baker and Shuksan.\r\n\r\nTake the side trip if you like, or continue right, though the meadow where several varieties of wildflowers bloom in August. Cross a small stream, and climb gradually up the meadow. Look behind you periodically, there is an excellent view of Mount Baker.\r\n\r\nAt the top of the meadow, enter a beautiful forest draped in moss. Descend steeply, taking note that you’ll have to climb this on the way back to your car. At least the trail is well-shaded. At 1.5 miles from the trailhead, arrive at another meadow and another junction.\r\n\r\nThe trail to the right heads half a mile downhill to lower Anderson Lake; a small lake surrounded by grassy meadows and an interesting wall of rocky gray pinnacles. Camping and a backcountry privy are available here.\r\n\r\nThe trail to the left continues 1.5 miles to Watson Lakes. It climbs briefly and then drops down to the lakes, crossing into the Noisy-Diobsud Wilderness along the way. The first lake is pretty and a worthwhile place to stop and have a snack. Camping is available, but it is not especially private.\r\n\r\nExtending Your Trip: For a more rugged experience, continue on to Upper Watson Lake, the more dramatic of the two. The shoreline and the walls are much rockier, distant mountains come into view, and the berries are prolific. The camping is also much better–several sites are located on rock outcroppings along the lake shore. A backcountry privy is available. Take your time to enjoy the scenery–your return hike is only 3 miles long. ',	'From I-5, take exit 230 and head east on Highway 20 for approximately 23 miles. Turn left on a paved road signed for Baker Lake Road between mile posts 82 and 83. At 14.2 miles, turn right onto a paved road signed for Baker Lake Dam Road. 1.7 miles along, cross the dam on a one-lane road, and 2.4 miles in, take a left onto FR-1107. Follow this good gravel road for 8.9 miles and arrive at a junction signed Anderson and Watson Lakes. Travel 1.1 miles on a bumpy gravel road. Privy and picnic table available at trailhead.',	NULL,	'0000-00-00 00:00:00');

SET foreign_key_checks = 1; #turn foreign key check back on