expanded_data = LOAD '/uhadoop2019/hearthstone-decks/expanded_data/' USING PigStorage('\t') AS (craft_cost, date, deck_archetype, deck_class, 
deck_format, deck_id, deck_set, deck_type, rating, title, user, card);
cards = LOAD 'hdfs://cm:9000/uhadoop2019/hearthstone-decks/cards.csv' USING PigStorage(',') AS (id,name,class,cost,rarity,set);

expanded_data_filtered = FILTER expanded_data BY deck_type == 'Ranked Deck';

--tenemos las cartas unicas por nombre
cards_and_deck = FOREACH expanded_data_filtered GENERATE deck_id, card;
cards_and_deck_unique = DISTINCT cards_and_deck;
cards_and_deck_name = JOIN cards_and_deck_unique BY card, cards BY id;
simple_cards_and_deck = FOREACH cards_and_deck_name GENERATE deck_id, name AS card;
--fin

--cuantas veces aparece cada carta
grouped_cards = GROUP simple_cards_and_deck BY card;
card_count = FOREACH grouped_cards GENERATE COUNT($1) AS count, group AS card;
--fin

--join para saber cuantas veces aparece cada carta junto a las cartas con el mazo
cards_and_deck_counted = JOIN card_count BY card, simple_cards_and_deck BY card;


cards_and_deck_alias = FOREACH cards_and_deck_counted GENERATE card_count::card AS card, deck_id AS deck_id, count AS count;
card_pairs = JOIN cards_and_deck_counted BY deck_id, cards_and_deck_alias BY deck_id;
card_pairs_unique = FILTER card_pairs BY cards_and_deck_counted::card_count::card < cards_and_deck_alias::card;


--card_pairs_together = FOREACH card_pairs_unique GENERATE CONCAT(cards_and_deck_counted::card_count::card,'##',
--cards_and_deck_alias::card)
 --AS card_pair, cards_and_deck_counted::card_count::card AS card1, cards_and_deck_alias::card AS card2, 
--cards_and_deck_counted::card_count::count AS count1, cards_and_deck_alias::count AS count2;

card_pairs_together = FOREACH card_pairs_unique GENERATE CONCAT(cards_and_deck_counted::card_count::card,'##',
cards_and_deck_alias::card)
 AS card_pair, (double)cards_and_deck_counted::card_count::count AS count1, (double)cards_and_deck_alias::count AS count2;


card_pairs_grouped = GROUP card_pairs_together BY (card_pair, count1, count2);

card_pair_count = FOREACH card_pairs_grouped GENERATE COUNT($1) AS count, group AS pair_counts;

card_pair_flattened = FOREACH card_pair_count GENERATE (double)count, FLATTEN(pair_counts) AS (card_pair, count1, count2);

card_pair_formula = FOREACH card_pair_flattened GENERATE card_pair, (count / (count1 + count2)) AS result, count, count1, count2;

final_result = ORDER card_pair_formula BY result DESC; 

final_result_limited = LIMIT final_result 200;

STORE final_result_limited INTO '/uhadoop2019/hearthstone-decks/card_pairs/';

datos = LOAD '/uhadoop2019/hearthstone-decks/card_pairs/' USING PigStorage('\t') AS (card_pair, result);
DUMP datos;

---Screen 26431