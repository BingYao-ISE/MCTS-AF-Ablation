# Simulation Optimization of Spatiotemporal Dynamics in 3D Geometries

Many engineering and healthcare systems are featured with spatiotemporal dynamic processes. The optimal control of such systems often involves sequential decision making. However, traditional sequential decision-making methods are not applicable to optimize dynamic systems that involves complex 3D geometries. Simulation modeling offers an unprecedented opportunity to evaluate alternative decision options and search for the optimal plan. In this paper, we develop a novel simulation optimization framework for sequential optimization of 3D dynamic systems. We first propose to measure the similarity between functional simulation outputs using coherence to assess the effectiveness of decision actions. Second, we develop a novel Gaussian Process (GP) model by constructing a valid kernel based on Hausdorff distance to estimate the coherence for different decision paths. Finally, we devise a new Monte Carlo Tree Search (MCTS) algorithm, i.e., Normal-Gamma GP MCTS (NG-GP-MCTS), to sequentially optimize the spatiotemporal dynamics. We implement the NG-GP-MCTS algorithm to design an optimal ablation path for restoring normal sinus rhythm (NSR) from atrial fibrillation (AF). We evaluate the performance of NG-GP-MCTS with spatiotemporal cardiac simulation in a 3D atrial geometry. Computer experiments show that our algorithm is highly promising for designing effective sequential procedures to optimize spatiotemporal dynamics in complex geometries. Note to Practitioners—This article proposes a novel simulation optimization framework for sequential decision making to optimize spatiotemporal dynamics in complex geometries. This framework incorporates the advantage of Bayesian modeling and Gaussian Process inference into Monte-Carlo tree search to effectively solve the sequential optimization problem. It has significant potential to contribute to the emerging discipline of computational engineering and medicine, and further realize precision control/treatment planning in various manufacturing and healthcare systems. This paper will be interesting to practitioners who are seeking effective computational and optimization tools for decision support to optimally control dynamic systems for restoring normal system functionality.

This repository shows the Matlab code for the above paper.


# Requirement

Tree data structure as a MATLAB class [1].

[1] Jean-Yves Tinevez (2025). Tree data structure as a MATLAB class (https://tinevez.github.io/matlab-tree/).


# Citation
Please cite our paper if you use our code in your research:

@article{yao2025simulation,
  title={Simulation Optimization of Spatiotemporal Dynamics in 3D Geometries},
  author={Yao, Bing and Leonelli, Fabio and Yang, Hui},
  journal={IEEE Transactions on Automation Science and Engineering},
  year={2025},
  publisher={IEEE}
}