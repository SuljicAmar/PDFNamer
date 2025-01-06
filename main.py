from fastapi import FastAPI
from fastapi.responses import JSONResponse
import json
from pydantic import BaseModel
from ollama import generate


class ToClient(BaseModel):
    title: str
    author: str
    subject: str
    dateCreated: str


_model = "gemma2:2b"
_options = {"temperature": 0.7, "num_ctx": 20000}
_format = ToClient.model_json_schema()
_system_prompt = """You are an expert at finding and deducing key identifying information from text.
        You will be provided some brief context of .PDF files, it is your job to find and or deduce the title
        of the text, the last names of the author(s), the overall subject/topic of the text, and the date the text
        was created. The content is provided below: \n"""


def get_response_from_llm(content):
    try:
        return generate(
            model=_model,
            system=_system_prompt,
            prompt=content,
            options=_options,
            format=_format,
        ).response
    except Exception as e:
        print(f"Error in LLM generation: {e}")
        return {
            "title": "",
            "author": "",
            "subject": "",
            "dateCreated": "",
        }


class FromClient(BaseModel):
    content: str


app = FastAPI()


@app.post("/parse_content/")
async def parse_content(response_from_client: FromClient):
    try:
        ai_response = get_response_from_llm(response_from_client.content)
        return JSONResponse(content=json.loads(ai_response), status_code=200)
    except Exception as e:
        return JSONResponse(content={"error": str(e)}, status_code=500)
