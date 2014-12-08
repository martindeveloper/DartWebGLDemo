part of Game;

class TriangleEntity implements IEntity {
  RenderingContext Context;
  Shader VertexShader;
  Shader FragmentShader;
  Program ShaderProgram;
  Buffer VertexBuffer;
  Float32List Vertices;

  double ScalingStep = 0.001;

  void PrepareRendering(RenderingContext GlContext) {
    Context = GlContext;

    print("TriangleEntity: Creating VS, FS, program and VB");

    VertexShader = Context.createShader(RenderingContext.VERTEX_SHADER);
    FragmentShader = Context.createShader(RenderingContext.FRAGMENT_SHADER);

    Context.shaderSource(VertexShader, """
    attribute vec2 coordinates;
    void main() {
      gl_Position = vec4(coordinates, 1.0, 1.0);
    }
    """);
    Context.compileShader(VertexShader);

    Context.shaderSource(FragmentShader, """
    void main() {
      gl_FragColor = vec4(0.0, 0.5, 1.0, 0.2);
    }
    """);
    Context.compileShader(FragmentShader);

    ShaderProgram = Context.createProgram();
    Context.attachShader(ShaderProgram, VertexShader);
    Context.attachShader(ShaderProgram, FragmentShader);

    Context.linkProgram(ShaderProgram);

    if (Game.IsDebugEnabled) {
      if (!Context.getShaderParameter(VertexShader, RenderingContext.COMPILE_STATUS)) {
        print("VertexShader Error: " + Context.getShaderInfoLog(VertexShader));
      }

      if (!Context.getShaderParameter(FragmentShader, RenderingContext.COMPILE_STATUS)) {
        print("FragmentShader Error: " + Context.getShaderInfoLog(FragmentShader));
      }

      if (!Context.getProgramParameter(ShaderProgram, RenderingContext.LINK_STATUS)) {
        print("Shader Program Error: " + Context.getProgramInfoLog(ShaderProgram));
      }
    }

    PrepareBuffer();
  }

  void OnStart() {

  }

  void OnUpdate(GameTime time) {
    ScaleVertices(ScalingStep);
    Context.useProgram(ShaderProgram);

    int coordinatesLocation = Context.getAttribLocation(ShaderProgram, "coordinates");
    Context.enableVertexAttribArray(coordinatesLocation);
    Context.bindBuffer(RenderingContext.ARRAY_BUFFER, VertexBuffer);
    Context.vertexAttribPointer(coordinatesLocation, 3, RenderingContext.FLOAT, false, 0, 0);

    Context.drawArrays(RenderingContext.TRIANGLES, 0, 3);

    // Clean
    Context.disableVertexAttribArray(0);
    Context.useProgram(null);
    Context.bindBuffer(RenderingContext.ARRAY_BUFFER, null);
  }

  void OnFixedUpdate() {

  }

  void OnDestroy() {
    Context.deleteShader(VertexShader);
    Context.deleteShader(FragmentShader);
    Context.deleteProgram(ShaderProgram);
    Context.deleteBuffer(VertexBuffer);

    print("TriangleEntity: Deleting VS, FS, program and VB");
  }

  void PrepareBuffer() {
    VertexBuffer = Context.createBuffer(); // TODO: Create shared buffer.

    Vertices = new Float32List.fromList([
        -0.1, -0.1, 0.0,
        0.1, -0.1, 0.0,
        0.0, 0.1, 0.0,
    ]);

    Context.bindBuffer(RenderingContext.ARRAY_BUFFER, VertexBuffer);
    Context.bufferData(RenderingContext.ARRAY_BUFFER, Vertices, RenderingContext.DYNAMIC_DRAW);
  }

  void ScaleVertices(double step) {
    for (int i = 0; i < Vertices.length; i++) {
      if (Vertices[i] > 0) {
        Vertices[i] = Vertices[i] + step;
      }
      else if (Vertices[i] < 0) {
        Vertices[i] = Vertices[i] - step;
      }
    }

    Context.bindBuffer(RenderingContext.ARRAY_BUFFER, VertexBuffer);
    Context.bufferData(RenderingContext.ARRAY_BUFFER, Vertices, RenderingContext.DYNAMIC_DRAW);
  }
}