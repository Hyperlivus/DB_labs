INSERT INTO client (email, tag, nickname) VALUES ('simple@gmail.com', 'simple_tag', 'SimpleUser');
INSERT INTO chat (name, tag, description) VALUES('Chat', 'chat', 'Simple-dimple chat');

SELECT * FROM chat WHERE tag = 'chat';
SELECT * FROM client WHERE id = 0;
SELECT * FROM client WHERE email = 'simple@gmail.com';
SELECT * FROM chat WHERE name ILIKE '%simple%' OR tag ILIKE '%simple%';

UPDATE client SET nickname = 'OtherSimpleName' WHERE id = 0;
UPDATE chat SET metadata = metadata || '_new' WHERE NOW() - created_at > INTERVAL '30 seconds';
UPDATE chat SET metadata = metadata || '_abandonmen' WHERE NOW() - last_activity_at > INTERVAL '30 days';
UPDATE chat SET last_activity_at = NOW();


DELETE FROM chat WHERE NOW() - last_activity_at > INTERVAL '7 days';
DELETE FROM client WHERE nickname ILIKE '%simple%' OR tag ILIKE '%simple%';