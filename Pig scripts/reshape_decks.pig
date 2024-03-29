decks = LOAD 'hdfs://cm:9000/uhadoop2019/hearthstone-decks/data.csv' USING PigStorage(',') AS 
(craft_cost, date, deck_archetype, deck_class, deck_format, deck_id, deck_set, deck_type, rating, title, user, 
card_0, card_1, card_2, card_3, card_4, card_5, card_6, card_7, card_8, card_9, card_10, card_11, card_12, card_13, card_14, 
card_15, card_16, card_17, card_18, card_19, card_20, card_21, card_22, card_23, card_24, card_25, card_26, card_27, 
card_28, card_29);

bagged_cards = FOREACH decks GENERATE craft_cost, date, deck_archetype, deck_class, deck_format, deck_id, deck_set, 
deck_type, rating, title, user, TOBAG(card_0, card_1, card_2, card_3, card_4, card_5, card_6, card_7, card_8, card_9, card_10, 
card_11, card_12, card_13, card_14, card_15, card_16, card_17, card_18, card_19, card_20, card_21, card_22, card_23, 
card_24, card_25, card_26, card_27, card_28, card_29) as cards;


flatten_cards = FOREACH bagged_cards GENERATE craft_cost, date, deck_archetype, deck_class, deck_format, 
deck_id, deck_set, deck_type, rating, title, user, FLATTEN(cards) as card;

STORE flatten_cards INTO '/uhadoop2019/hearthstone-decks/expanded_data/';

--Screen: 1639
--org.apache.pig.Main - Pig script completed in 8 minutes, 26 seconds and 662 milliseconds (506662 ms)