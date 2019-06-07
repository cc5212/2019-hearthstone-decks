-- This script count the number of decks of each deck archetype
decks = LOAD 'hdfs://cm:9000/uhadoop2019/hearthstone-decks/data.csv' USING PigStorage(',') AS (craft_cost, date, deck_archetype, deck_class, deck_format, deck_id, deck_set, deck_type, rating, title, user, card_0, card_1, card_2, card_3, card_4, card_5, card_6, card_7, card_8, card_9, card_10, card_11, card_12, card_13, card_14, card_15, card_16, card_17, card_18, card_19, card_20, card_21, card_22, card_23, card_24, card_25, card_26, card_27, card_28, card_29);
-- Group the decks by deck archetype
grouped_archetype = group decks by deck_archetype;
-- Generate the count for each deck archetype
archetype_count = FOREACH grouped_archetype GENERATE COUNT($1) as count, group as type;
-- Order descending by count
ordered_archetype_count = order archetype_count by count DESC;
-- Storing the ordered count to a file
STORE ordered_archetype_count INTO '/uhadoop2019/hearthstone-decks/ordered_archetype_count/';