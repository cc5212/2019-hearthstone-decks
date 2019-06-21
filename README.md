# 2019-hearthstone-decks
Analysis of hearthstone decks with Pig. [Sven Reisenegger, Pablo Torres, Patricio Taiba. Group 20]

# Overview

State what is the main goal of the project. State what sorts of question(s) you want to answer or what sort of system you want to build. (Questions may be non-technical -- e.g., is there a global correlation between coffee consumption and research output -- so long as they require data analysis or other technical solutions.)

Ojo que hay que ver los mazos de play mode (ranked deck, tournament)
Ideas
 - Contar mazos ranked con más de 50 upvotes (mazos buenos) 2178
 - Cartas mas populares (por set y por clase/neutrales), ver si fueron nerfeadas
 - Cartas neutrales mas populares 
 - Clases mas populares (por rotacion tal vez) x
 - Cartas que son populares juntas (usar como indicador la cantidad de veces que salen juntas/cantidad total de veces que sale cada una sumadas)
 - Ver cuantas cartas segun coste hay en cada mazo (ver curva promedio de los mazos)
 - Comparaciones entre las queries usando todo el dataset vs filtrando por buenos mazos
 - De cuales cartas se juega solo una copia
 - Ver clases mas populares con mazos baratos/caros
 - Mazos buenos con la mayor cantidad de cartas de alguna expansión específica.

# Data


Describe the raw dataset that you considered for your project. Where did it come from? Why was it chosen? What information does it contain? What format was it in? What size was it? How many lines/records? Provide links.

El dataset utilizado fue sacado de [Kaggle](https://www.kaggle.com/romainvincent/history-of-hearthstone) consta de 346.242 mazos (filas) de hearthstone en formato csv, cada fila contiene los siguientes datos (descripicón copiada de la página original):
- date (str) : the date of publication (or last update) of the deck.
- user (str) : the user who uploaded the deck.
- deck_class (str) : one of the nine character class in Hearthstone (Druid, Priest, ...).
- deck_archetype (str) : the theme of deck labelled by the user (Aggro Druid, Dragon Priest, ...).
- deck_format (str) : the game format of the deck on the day data was recorded (W for "Wild" or S for "Standard").
- deck_set (str) : the latest expansion published prior the deck publication (Naxxramas, TGT Launch, ...).
- deck_id (int) : the ID of the deck.
- deck_type (str) : the type of the deck labelled by the user :
  - Ranked Deck : a deck played on ladder.
  - Theorycraft : a deck built with unreleased cards to get a gist of the future metagame.
  - PvE Adventure : a deck built to beat the bosses in adventure mode.
  - Arena : a deck built in arena mode.
  - Tavern Brawl : a deck built for the weekly tavern brawl mode.
  - Tournament : a deck brought at tournament by a pro-player.
  - None : the deck type was not mentioned.
- rating (int) : the number of upvotes received by that deck.
- title (str) : the name of the deck.
- craft_cost (int) : the amount of dust (in-game craft material) required to craft the deck.
- cards (list) : a list of 30 card ids. Each ID can be mapped to the card description using the reference file.

Además del archivo csv, se tiene refs.json. Se copia la descripición de la página original:
Contains the reference to the cards played in Hearthstone. Each record features a lot of informations about the cards, I'll list the most important:

- dbfId (int) : the id of the card (the one used in data.json).
- rarity (str) : the rarity of the card (EPIC, RARE, ...).
- cardClass (str) : the character class (WARLOCK, PRIEST, ...).
- artist (str) : the artist behind the card's art.
- collectible (bool) : whether or not the card can be collected.
- cost (int) : the card play cost.
- health (int) : the card health (if it's a minion).
- attack (int) : the card attack (if it's a minion).
- name (str) : the card name.
- flavor (str) : the card's flavor text.
- set (str) : the set / expansion which featured this card.
- text (int) : the card's text.
- type (str) : the card's type (MINION, SPELL, ...).
- race (str) : the card's race (if it's a minion).
- set (str) : the set / expansion which featured this card.



# Methods

Detail the methods used during the project. Provide an overview of the techniques/technologies used, why you used them and how you used them. Refer to the source-code delivered with the project. Describe any problems you encountered.

Para el desarrollo de este proyecto se uso pricipalmente Apache Pig y en menor medida Python. Python se uso para prepocesar nuestros datos, primero para transformar el archivo refs.json a formato csv eliminando la información que no nos servía en el proceso, además también se uso para eliminar comas que habían en los campos del archivo de los mazos ya que hacían más complicado cargarlos en Pig. Por otro lado se uso Apache Pig para hacer consultas al dataset para responder las preguntas planteadas, se decidió usar esta tecnología ya que es de fácil uso y es adecuado para usar con el dataset de 346.242 filas que se transforman en 10.387.260 al separar los mazos por cartas.
En los scripts para [contar buenos mazos](Pig%20scripts/count_good_decks.pig), [contar los achetipos](Pig%20scripts/ordered_deck_archetype_count.pig) y las primeras dos consultas para [contar cartas](Pig%20scripts/count_cards.pig) se ve una lógica parecida a la usada en los laboratorios de agrupar y luego contar. Por otro lado el script para ver lo [pares de cartas populares](Pig%20scripts/card_pairs.pig) se uso una lógica parecida a la que se uso para contar co-estrellas en los laboratorios. Y por último en las consultas que entregas [los top 10 por clases y set](Pig%20scripts/count_cards.pig) se baso en el ejemplo mostrado en [esta respuesta](https://stackoverflow.com/a/17656762) de Stack Overflow.

# Results

Detail the results of the project. Different projects will have different types of results; e.g., run-times or result sizes, evaluation of the methods you're comparing, the interface of the system you've built, and/or some of the results of the data analysis you conducted.

# Conclusion

Summarise main lessons learnt. What was easy? What was difficult? What could have been done better or more efficiently?

# Appendix

You can use this for key code snippets that you don't want to clutter the main text.
