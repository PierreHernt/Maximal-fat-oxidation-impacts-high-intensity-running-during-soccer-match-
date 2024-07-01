# Maximal Fat Oxidation and High-Intensity Running Performance in Elite Soccer Players

## ABSTRACT
**Purpose** :  Maximal fat oxidation rates (MFO) is considered an important determinant of athletic performance in endurance sport, but studies have rarely investigated this issue in soccer. This study examined the possible associations between maximal fat oxidation and match running performance in elite soccer players, and aimed to assess the importance of maximal fat oxidation in match performance compared to other physical qualities more traditionally targeted by physical trainers (e.g., VO2max, strength, power).
**Methods** : During the pre-season training, 41 youth elite soccer players performed a maximal and fasted submaximal graded exercise test on a treadmill for the determination of peak oxygen uptake (VO2max) and MFO, respectively. Additionally, vertical and horizontal force-velocity-power profile were obtained for each soccer player. The match-running performance was measured by a global positioning system (GPS) over a competitive season.
**Results** :  Based on the weight of each variable obtained from 100 bootstraps on our regression trees, VO2max was identified as the most important variable for estimating total distance, F0 and Pmax for estimating sprint distance, and MFO for estimating high-intensity running (> 15km/h). Players exhibiting VO2max greater than 55.6 ml/min/kg covered more distance than others (P<0.05), and players with a MFO greater than 0.73 g/min covered more high-intensity distance (P<0.05). 
**Conclusion** : This study identifies a specific threshold of approximately 0.7 g/min for maximal fat oxidation, which could serve as a benchmark for physical staff in elite soccer clubs. This finding support that maximal fat oxidation play an important role in high-intensity running performance during soccer game. Optimizing physical performance and endurance in soccer requires a holistic training approach that targets lower limb explosiveness, aerobic power, and fat oxidation, recognizing the multifaceted nature of high-intensity effort. 
**Keywords**: fat oxidation, exercise physiology, football, metabolic profile, anaerobic threshold

## DATASET


## CODE 

**SIMPLE_TREE** :  A simplified regression tree model with one split. The results of this model are illustrated in our figures. The main split threshold of the tree was selected to segment individuals based on the physiological variable most associated with our GPS variable of interest.

**VARIABLES_IMPORTANCES** : To analyze the impact of various physiological variables on the measured GPS data, regression trees were used, and their importance was assessed using 1000 bootstrap samples. This method aims to provide stable estimates of variable importance, expressed as mean ± SD. The following equation was used for this purpose:

![image](https://github.com/PierreHernt/Maximal-fat-oxidation-impacts-high-intensity-running-during-soccer-match-/assets/120321905/9875a039-15ee-45cf-a0d6-eee674fee4c5)


- **A**: Decision tree.
- **t**: A node in the tree.
- **ΔR̂**: Reducing prediction error.
- **dₘ(t)**: The decision (or split) is made using the variable Xₘ at node t.

