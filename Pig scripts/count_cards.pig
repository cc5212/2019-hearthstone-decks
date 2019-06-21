flatten_cards = LOAD '/uhadoop2019/hearthstone-decks/expanded_data/' USING PigStorage('\t') AS (craft_cost, date, deck_archetype, deck_class, 
deck_format, deck_id, deck_set, deck_type, rating, title, user, card);
cards = LOAD 'hdfs://cm:9000/uhadoop2019/hearthstone-decks/cards.csv' USING PigStorage(',') AS (id,name,class,cost,rarity,set);

grouped_cards = GROUP flatten_cards BY card;
card_count = FOREACH grouped_cards GENERATE COUNT($1) AS count, group AS card;
card_count_with_name = JOIN card_count BY card, cards BY id;
simple_card_count = FOREACH card_count_with_name GENERATE name, count;
ordered_card_count = ORDER simple_card_count BY count DESC;
STORE ordered_card_count INTO '/uhadoop2019/hearthstone-decks/ordered_card_count/';

unique_cards = DISTINCT flatten_cards;
unique_grouped_cards = GROUP unique_cards BY card;
unique_card_count = FOREACH unique_grouped_cards GENERATE COUNT($1) AS count, group AS card;
unique_card_count_with_name = JOIN unique_card_count BY card, cards BY id;
unique_simple_card_count = FOREACH unique_card_count_with_name GENERATE name, count;
unique_ordered_card_count = ORDER unique_simple_card_count BY count DESC;
STORE unique_ordered_card_count INTO '/uhadoop2019/hearthstone-decks/unique_ordered_card_count/';

cards_with_set_class = FOREACH unique_card_count_with_name GENERATE name, count, set, class;
grouped_by_set = GROUP cards_with_set_class BY set;
top10_set = FOREACH grouped_by_set {
	sorted = ORDER cards_with_set_class BY count DESC;
	top = LIMIT sorted 10;
	GENERATE group, FLATTEN(top); 
};
STORE top10_set INTO '/uhadoop2019/hearthstone-decks/top-10-by-set'

grouped_by_class = GROUP cards_with_set_class BY class;
top10_class = FOREACH grouped_by_class {
	sorted = ORDER cards_with_set_class BY count DESC;
	top = LIMIT sorted 10;
	GENERATE group, FLATTEN(top); 
};
STORE top10_class INTO '/uhadoop2019/hearthstone-decks/top-10-by-class'