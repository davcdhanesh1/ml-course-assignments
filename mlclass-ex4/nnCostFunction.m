function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

Y = zeros(size(y,1),num_labels);
for i = 1:size(Y,1)
  Y(i,y(i)) = 1;
end 


% ====================== YOUR CODE HERE ==================================================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
% =========================================================================================


% Calculating forward feed propagation

% activation a1, input layer
layer1BaseUnit = ones(size(X,1),1);
layer1 = [layer1BaseUnit X]; 

% activation a2, hidden layer
Z2 = layer1 * (Theta1)';
layer2 = sigmoid(Z2);
layer2BaseUnit = ones(size(layer2,1), 1);
layer2 = [layer2BaseUnit layer2]; 

% activation a3, output layer
Z3 = layer2 * (Theta2)';
layer3 = sigmoid(Z3);

% Calculating cost function of all labels
J = zeros(size(num_labels,1));
for k = 1:num_labels 
   J(k) = (-1) * Y(:,k)' * log(layer3(:,k)) - (1 - Y(:,k)') * log(1 - layer3(:,k));
end
J = sum(J) / m;

% chopping of bias unit from each layer for calculating regularization factor
Theta1 = Theta1(:,2:end);
Theta2 = Theta2(:,2:end);

factor1 = 0;
factor2 = 0;
for j = 1:hidden_layer_size
  for k = 1:input_layer_size
    factor1 = factor1 + Theta1(j,k).^2;
  end
end
for j = 1:num_labels
  for k = 1:hidden_layer_size
    factor2 = factor2 + Theta2(j,k).^2;
  end
end  
regularization_factor = (lambda / ( 2 * m)) * (factor1 + factor2);

J = J + regularization_factor;

% Unroll gradients
for i = 1:m
  delta3 = layer3(i,:) - Y(i,:);
  Theta2_grad = Theta2_grad + delta3' * layer2(i,:);
  delta2 = (delta3 * Theta2) .* sigmoidGradient(Z2(i,:));
  Theta1_grad = Theta1_grad + delta2' * layer1(i,:);
end

Theta1_grad = (1 / m) * Theta1_grad + (lambda / m ) * [zeros(size(Theta1,1),1), Theta1];
Theta2_grad = (1 / m) * Theta2_grad + (lambda / m ) * [zeros(size(Theta2,1),1), Theta2];

grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
