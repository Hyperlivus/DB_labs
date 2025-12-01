-- кількість та тип реакції на повідомлення
SELECT 
    rt.tag,
    rt.icon_url,
    rt.label,
    COUNT(r.id) AS reaction_count
FROM reaction r
JOIN reaction_type rt ON r.type_id = rt.id
WHERE r.message_id = 2
GROUP BY rt.tag, rt.icon_url, rt.label
ORDER BY reaction_count DESC;

-- сортуємо повідомлення за рейтингом (беремо тільки з позитивним рейтингом)
SELECT msg.id, msg.content, COALESCE(SUM(rt.rate), 0.0) AS rating
FROM message msg
LEFT JOIN reaction r ON r.message_id = msg.id
LEFT JOIN reaction_type rt ON r.type_id = rt.id
LEFT JOIN member mb ON msg.creator_id = mb.id
WHERE mb.chat_id = 4
GROUP BY msg.id
HAVING COALESCE(SUM(rt.rate), 0.0) > 0.0
ORDER BY rating DESC;

-- виводимо юзерів в чаті повідомлення яких мають найбільший рейтинг
SELECT mb.id, cln.nickname, cln.tag, COALESCE(SUM(rt.rate)) AS rating
FROM member mb
LEFT JOIN client cln ON mb.client_id = cln.id
LEFT JOIN message msg ON msg.creator_id = mb.id
LEFT JOIN reaction r ON r.message_id = msg.id
LEFT JOIN reaction_type rt ON r.type_id = rt.id
WHERE mb.chat_id = 4
GROUP BY mb.id
ORDER BY rating

-- сортуємо всі чати в яких є юзер за часом їх створення
SELECT mmb.*, cht.tag, cht.name, cht.avatar_url, cht.description, cht.created_at FROM member mmb
LEFT JOIN chat cht ON mmb.chat_id = cht.id
WHERE mmb.client_id = 4
GROUP BY mmb.id, cht.id
ORDER BY cht.created_at

-- виводимо три найпопулярніші реакції в чаті
SELECT rt.id, rt.label, COUNT(r.id) as react_count
FROM reaction_type rt
LEFT JOIN member mb ON mb.chat_id = 4
LEFT JOIN reaction r ON r.owner_id = mb.id AND r.type_id = rt.id
GROUP BY rt.id
HAVING COUNT(r.id) > 0.0
ORDER BY react_count DESC