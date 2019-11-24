defmodule GameEcs.Export do
  @path "../game_display/display_output.json"
  
  def export_logs(recorder) do
    output = generate_output(recorder)
    File.write(@path, Jason.encode!(output), [:utf8])
  end

  defp open_file() do
    File.open!("output.html", [:write, :utf8])
  end

  defp generate_output(recorder) do
    %{
      logs: format_logs(recorder.logs),
      entities: format_entities(recorder.entities),
    }
  end
  
  defp format_logs(logs) do
    logs
    |> Enum.map(fn line ->
      {msg, tags} = line
      %{msg: msg, tags: tags}
    end)
  end
  
  defp format_entities(entities) do
    entities
  end
end