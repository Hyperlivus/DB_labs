INSERT INTO client (email, tag, nickname) VALUES ('simple@gmail.com', 'simple_tag', 'SimpleUser');
INSERT INTO chat (name, tag, description) VALUES('Chat', 'chat', 'Simple-dimple chat');
INSERT INTO member(client_role, chat_id, client_id) VALUES ('member', 0, 0);

INSERT INTO message (creator_id, chat_id, content) VALUES(0, 0, 'Hello world!!'), 
(0, 0, 'Simple-dimple word'),
(0, 0, 'Goodbay world!!');

INSERT INTO reaction_type (tag, label, icon_url, rate) VALUES('like', 'Like', 'like.svg', 1.0);
INSERT INTO reaction_type (tag, label, icon_url, rate) VALUES('dislike', 'Dislike', 'dislike.svg', -1.0);
INSERT INTO reaction_type (tag, label, icon_url, rate) VALUES('angry', 'Angry', 'angry.svg', -2.0);
INSERT INTO reaction_type (tag, label, icon_url) VALUES('clown', 'Clowm', 'clown.svg', -3.0);

INSERT INTO reaction (owner_id, message_id, type_id) VALUES
   (0, 2, 1),
   (0, 2, 2),
   (0, 3, 1),
   (0, 4, 2);


-- кількість та тип реакції на повідомлення
SELECT 
    rt.tag,
    rt.icon_url,
    rt.label,
    COUNT(r.id) AS reaction_count
FROM reaction r
JOIN reaction_type rt ON r.type_id = rt.id
WHERE r.message_id = 1
GROUP BY rt.tag, rt.icon_url
ORDER BY reaction_count DESC;

-- сортуємо повідомлення за рейтингом
SELECT msg.*, COALESCE(SUM(rt.rate), 0.0) AS rating
FROM message msg
LEFT JOIN reaction r ON r.message_id = msg.id
LEFT JOIN reaction_type rt ON r.type_id = rt.id
WHERE msg.chat_id = 4
GROUP BY msg
ORDER BY rating DESC;


-- сортуємо всі чати в яких є юзер за часом їх створення
SELECT mmb.*, cht.tag, cht.name, cht.avatar_url, cht.description, cht.created_at FROM member mmb
LEFT JOIN chat cht ON mmb.chat_id = cht.id
WHERE mmb.client_id = 4
GROUP BY mmb.id, cht.id
ORDER BY cht.created_at