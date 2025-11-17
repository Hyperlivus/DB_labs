INSERT INTO client (email, tag, nickname) VALUES ('simple@gmail.com', 'simple_tag', 'SimpleUser');
INSERT INTO chat (name, tag, description) VALUES('Chat', 'chat', 'Simple-dimple chat');
INSERT INTO member(client_role, chat_id, client_id) VALUES ('member', 0, 0);

INSERT INTO message (creator_id, chat_id, content) VALUES(0, 0, 'Hello world!!'), 
(0, 0, 'Simple-dimple word'),
(0, 0, 'Goodbay world!!');

INSERT INTO reaction_type (tag, label, icon_url) VALUES('like', 'Like', 'like.svg');
INSERT INTO reaction_type (tag, label, icon_url) VALUES('dislike', 'Dislike', 'dislike.svg');
INSERT INTO reaction_type (tag, label, icon_url) VALUES('angry', 'Angry', 'angry.svg');
INSERT INTO reaction_type (tag, label, icon_url) VALUES('calm', 'Calm', 'calm.svg');

INSERT INTO reaction (owner_id, message_id, type_id) VALUES
   (0, 2, 1),
   (0, 2, 2),
   (0, 3, 1),
   (0, 4, 2);

SELECT 
    rt.tag,
    COUNT(r.id) AS reaction_count
FROM reaction r
JOIN reaction_type rt ON r.type_id = rt.id
GROUP BY rt.tag
ORDER BY reaction_count DESC;

SELECT 
    rt.tag,
    COUNT(*) AS count
FROM reaction r
JOIN reaction_type rt ON r.type_id = rt.id
WHERE r.owner_id = 0
GROUP BY rt.tag;

SELECT 
    rt.tag,
    rt.icon_url,
    COUNT(r.id) AS reaction_count
FROM reaction r
JOIN reaction_type rt ON r.type_id = rt.id
WHERE r.message_id = $1      -- подставляешь id сообщения
GROUP BY rt.tag, rt.icon_url
ORDER BY reaction_count DESC;

SELECT
    m.id AS message_id,
    m.content,
    m.creator_id,
    m.chat_id,
    m.created_at,
    COUNT(r.id) AS reaction_count
FROM message m
LEFT JOIN reaction r ON r.message_id = m.id
GROUP BY m.id
ORDER BY reaction_count DESC;

SELECT 
    m.id AS message_id,
    m.content,
    COUNT(r.id) AS reaction_count
FROM message m
LEFT JOIN reaction r ON r.message_id = m.id
GROUP BY m.id
HAVING COUNT(r.id) > 1
ORDER BY reaction_count DESC;
