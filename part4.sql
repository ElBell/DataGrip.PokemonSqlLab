# Rows are ordered by number of level 100s then type diversity then HP total
SELECT PokemonLevelType.pokemon AS Pokemon_Name,
       trainername AS Trainer_Name,
       PokemonLevelType.pokelevel AS Level,
       PokemonLevelType.primary_type AS Primary_Type,
       PokemonLevelType.secondary_type AS Secondary_Type
FROM
  trainers
    INNER JOIN (
    SELECT PokemonType.pokemon,
           pokelevel,
           PokemonType.primary_type,
           PokemonType.secondary_type,
           pokemon_trainer.trainerID,
           TrainerSort.HP_Total,
           TrainerSort.Level_100s,
           TrainerSort.Type_Diversity
    FROM
      pokemon_trainer
        INNER JOIN (
        SELECT pokemons.name        AS pokemon,
               types_primary.name   AS primary_type,
               types_secondary.name AS secondary_type,
               pokemons.id
        FROM pokemons
               JOIN types types_primary ON types_primary.id = primary_type
               LEFT OUTER JOIN types types_secondary ON types_secondary.id = secondary_type
      ) PokemonType
                   ON pokemon_trainer.pokemon_id = PokemonType.id
        INNER JOIN (
        SELECT pokemon_trainer.trainerID,
               COUNT(*) AS Level_100s,
               COALESCE(
                     SUM(DISTINCT pokemons.primary_type) + SUM(DISTINCT pokemons.secondary_type),
                     SUM(DISTINCT pokemons.primary_type)) AS Type_Diversity,
               SUM(maxhp) AS HP_Total
        FROM pokemon_trainer
               JOIN pokemons
                    ON pokemon_trainer.pokemon_id = pokemons.id
        WHERE pokelevel = 100
        GROUP BY trainerID
      ) TrainerSort
                   ON pokemon_trainer.trainerID = TrainerSort.trainerID
  ) PokemonLevelType
               ON trainers.trainerID = PokemonLevelType.trainerID
ORDER BY Level_100s DESC ,
         Type_Diversity DESC ,
         HP_Total DESC