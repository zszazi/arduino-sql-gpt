import gradio as gr
from utils import transcribe

demo = gr.Interface(
    transcribe, gr.Audio(sources=["microphone"]), ["text", "text", "text", "text"]
)

demo.launch()