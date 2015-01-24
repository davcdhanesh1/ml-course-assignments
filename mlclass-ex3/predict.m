function p = predict(Theta1, Theta2, X)
%PREDICT Predict the label of an input given a trained neural network
%   p = PREDICT(Theta1, Theta2, X) outputs the predicted label of X given the
%   trained weights of a neural network (Theta1, Theta2)

% Useful values
m = size(X, 1);
num_labels = size(Theta2, 1);

% You need to return the following variables correctly 
p = zeros(size(X, 1), 1);

% Adding bias unit in each layer
X = [ones(size(X,1),1) X];

%Theta1 = [ones(size(Theta1,1), 1) Theta1];
%Theta2 = [ones(size(Theta2,1), 1) Theta2];

% ====================== YOUR CODE HERE ======================
% Instructions: Complete the following code to make predictions using
%               your learned neural network. You should set p to a 
%               vector containing labels between 1 to num_labels.
%
% Hint: The max function might come in useful. In particular, the max
%       function can also return the index of the max element, for more
%       information see 'help max'. If your examples are in rows, then, you
%       can use max(A, [], 2) to obtain the max for each row.
%
% =========================================================================

% layer1 is input layer
layer1 = X;

% layer2 is hidden layer
layer2 = sigmoid(layer1 * (Theta1)');
layer2BaseUnit = ones(size(layer2,1), 1);
layer2 = [layer2BaseUnit layer2];

% layer3 is output layer
layer3 = sigmoid(layer2 * (Theta2)');

[maxValue, index] = max(layer3, [], 2);
p = index;
end
