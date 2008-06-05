CREATE TABLE calendar_dates ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "value" date NOT NULL, "calendar_id" integer NOT NULL, "weekday" integer NOT NULL, "monthweek" integer NOT NULL, "monthday" integer NOT NULL, "holiday" boolean DEFAULT 'f' NOT NULL);
CREATE TABLE calendar_events ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "calendar_id" integer NOT NULL, "start_date" date DEFAULT NULL, "end_date" date DEFAULT NULL);
CREATE TABLE calendar_occurrences ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "calendar_event_id" integer NOT NULL, "calendar_date_id" integer NOT NULL);
CREATE TABLE calendar_recurrences ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "calendar_event_id" integer NOT NULL, "weekday" integer DEFAULT NULL, "monthweek" integer DEFAULT NULL, "monthday" integer DEFAULT NULL);
CREATE TABLE calendars ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL);
CREATE TABLE events ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255) NOT NULL);
CREATE TABLE schema_info (version integer);
CREATE VIEW calendar_event_dates AS
      SELECT
      ce.id AS calendar_event_id,
      cd.id AS calendar_date_id
      FROM calendar_dates cd
      INNER JOIN calendar_events ce ON cd.holiday = 'f'
        AND (ce.start_date IS NULL OR cd.value >= ce.start_date)
        AND (ce.end_date IS NULL OR cd.value <= ce.end_date)
      LEFT OUTER JOIN calendar_occurrences co
        ON co.calendar_event_id = ce.id
        AND co.calendar_date_id = cd.id
      LEFT OUTER JOIN calendar_recurrences cr ON cr.calendar_event_id = ce.id
        AND ((cr.monthday IS NOT NULL AND cd.monthday = cr.monthday)
          OR (cr.monthday IS NULL AND cr.weekday IS NOT NULL
            AND cd.weekday = cr.weekday
              AND (cr.monthweek IS NULL OR cd.monthweek = cr.monthweek)
          )
        )
      WHERE cr.id IS NOT NULL OR co.id IS NOT NULL;
INSERT INTO schema_info (version) VALUES (2)