function out = sxfun(f, inArgs, options)
%SXFUN  applies the function f element-wise to each n-tuple of elements
%specified by inArgs, with implicit expansion (scalar expansion) enabled.

%% input validation
arguments
    f (1, 1) function_handle
end
arguments (Repeating)
    inArgs
end
arguments
    options.ParallelOptions (1, 1) = Inf
    options.PreindexArguments (1, 1) logical = true
end
% validate that inputs are compatible sizes with each other, and get the
% size of each input. Validation guarantees inArgSizeMat is appropriate
% format
inArgSizeArr = validateScalarExpandable(inArgs{:});

%% Preallocate out
% To preallocate space for out, we need to know how much space out will
% need. This is determined by the shape of the output and the class of each
% element.
% The shape of the output will be given by the scalar expansion of inArgs.
% outArgSize is length 1 in a dimension if and only if all inArgs are
% length 1 in that dimension.
inArgVectorDims = inArgSizeArr ~= 1;
outVectorDim = any(inArgVectorDims);
outSize = double(~outVectorDim);
% Since the inputs are validated for scalar expansion, the dimensions where
% any inArg are not length 1 all have the same length, so finding the first
% instance is sufficient to set the output dimension.
outSize(outVectorDim) = arrayfun(@(idx)( ...
    inArgSizeArr(find(inArgVectorDims(:, idx), 1), idx)), ...
    find(outVectorDim));
% the function must be run once in order to determin the class of the
% output. For implicit allocation of space, the last element of out is
% found, and then out is reshaped to outSize. NOTE: Each pair of elements
% in inArg, when applied as arguments to f, must give the same class of
% output. All outputs of f which are not the class of the last output of f
% will either be converted to that class or result in an error.
numelModuli = circshift(cumprod(outSize), 1);
lastArg = cellfun(@(arg)(arg(end)), inArgs, UniformOutput=false);
out(numelModuli(1)) = f(lastArg{:});
out = reshape(out, outSize);

%% Reindexing functions
[numArgs, numDims] = size(inArgSizeArr);
    function dimIdx = nestedIdx2DimIdx(idx)
        dimIdx(size(idx, 1), 1, numDims) = 0;
        dimIdx(:, 1, 1) = mod(idx-1, numelModuli(numDims))+1;
        dimIdx(:, 1, numDims) = (idx - dimIdx(:, 1, 1))./ ...
            numelModuli(numDims)+1;
        for i = numDims-1:-1:2
            idx = dimIdx(:, 1, 1);
            dimIdx(:, 1, 1) = mod(idx-1, numelModuli(i))+1;
            dimIdx(:, 1, i) = (idx - dimIdx(:, 1, 1))./numelModuli(i)+1;
        end
    end
idx2DimIdx = @(idx)(nestedIdx2DimIdx(idx));

numelPrevDims = permute(cumprod(inArgSizeArr(:, 1:end-1), 2), [3 1 2]);
    function ptr = nestedArgDimIdx2ArgIdx(ptr)
        ptr(:, :, 2:numDims) = (ptr(:, :, 2:numDims)-1).*numelPrevDims;
        ptr = sum(ptr, 3);
    end
argDimIdx2ArgIdx = @(ptr)(nestedArgDimIdx2ArgIdx(ptr));

%% parallelized iteration
inArgSizeArr = permute(inArgSizeArr, [3 1 2]);
idx = 1:numelModuli(1)-1;
argIdxRange = numArgs:-1:1;
if options.PreindexArguments %% Preindex arguments
    
    argIndices = argDimIdx2ArgIdx(min(idx2DimIdx(idx.'), inArgSizeArr));
    % for idx = idx
    parfor(idx = idx, options.ParallelOptions)
        argsAtIdx = cell([1 numArgs]);
        for argIdx = argIdxRange
            argsAtIdx{argIdx} = ...
                inArgs{argIdx}(argIndices(idx, argIdx)); %#ok<PFBNS>
        end
        out(idx) = f(argsAtIdx{:}); %#ok<PFBNS>
    end

else %% Iterate over argument indices
    
    % for idx = idx
    parfor(idx = idx, options.ParallelOptions)
        argIndices = argDimIdx2ArgIdx( ...
            min(feval(idx2DimIdx, idx), inArgSizeArr)); %#ok<FVAL>
        argsAtIdx = cell([1 numArgs]);
        for argIdx = argIdxRange
            argsAtIdx{argIdx} = ...
                inArgs{argIdx}(argIndices(argIdx)); %#ok<PFBNS>
        end
        out(idx) = f(argsAtIdx{:}); %#ok<PFBNS>
    end
end

end
