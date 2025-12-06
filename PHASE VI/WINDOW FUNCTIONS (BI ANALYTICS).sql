--Ranking Staff by # of Interactions

SELECT staff_id, 
       COUNT(*) AS total_interactions,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS interaction_rank
FROM interactions
GROUP BY staff_id;

---Compare Interaction Dates – LAG/LEAD

SELECT interaction_id,
       interaction_date,
       LAG(interaction_date) OVER (ORDER BY interaction_date) AS previous_interaction,
       LEAD(interaction_date) OVER (ORDER BY interaction_date) AS next_interaction
FROM interactions;

---ROW_NUMBER() per Client

SELECT client_id, interaction_id,
       ROW_NUMBER() OVER (PARTITION BY client_id ORDER BY interaction_date) AS seq_num
FROM interactions;



