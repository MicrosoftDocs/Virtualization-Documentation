FROM mcr.microsoft.com/windows:1909

WORKDIR C:/App

# Download and extract the ONNX model to be used for evaluation.
RUN curl.exe -o tiny_yolov2.tar.gz https://onnxzoo.blob.core.windows.net/models/opset_7/tiny_yolov2/tiny_yolov2.tar.gz && \
    tar.exe -xf tiny_yolov2.tar.gz && \
    del tiny_yolov2.tar.gz

# Download and extract cli tool for evaluation .onnx model with WinML.
RUN curl.exe -L -o WinMLRunner_x64_Release.zip https://github.com/microsoft/Windows-Machine-Learning/releases/download/1.2.1.1/WinMLRunner.v1.2.1.1.zip && \
    tar.exe -xf C:/App/WinMLRunner_x64_Release.zip && \
    del WinMLRunner_x64_Release.zip

# Run the model evaluation when container starts.
ENTRYPOINT ["C:/App/WinMLRunner v1.2.1.1/x64/WinMLRunner.exe", "-model", "C:/App/tiny_yolov2/model.onnx", "-terse", "-iterations", "100", "-perf"]
