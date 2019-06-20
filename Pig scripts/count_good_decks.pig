decks = LOAD 'hdfs://cm:9000/uhadoop2019/hearthstone-decks/data.csv' USING PigStorage(',') AS (craft_cost, date, deck_archetype, deck_class, deck_format, deck_id, deck_set, deck_type, rating:int, title, user, card_0, card_1, card_2, card_3, card_4, card_5, card_6, card_7, card_8, card_9, card_10, card_11, card_12, card_13, card_14, card_15, card_16, card_17, card_18, card_19, card_20, card_21, card_22, card_23, card_24, card_25, card_26, card_27, card_28, card_29);

filtered_by_rating = FILTER decks BY rating >= 50; 

filtered_group_all = GROUP filtered_by_rating ALL;

counted = FOREACH filtered_group_all GENERATE COUNT(filtered_by_rating);

DUMP counted;
