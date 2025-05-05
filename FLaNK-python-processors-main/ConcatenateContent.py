from nifiapi.flowfiletransform import FlowFileTransform, FlowFileTransformResult
from nifiapi.properties import PropertyDescriptor, StandardValidators, ExpressionLanguageScope

class ConcatenateFlowFileContent(FlowFileTransform):
    class Java:
        implements = ['org.apache.nifi.python.processor.FlowFileTransform']

    class ProcessorDetails:
        version = '2.0.0'
        description = "Concatenates the content of multiple FlowFiles into a single FlowFile."
        tags = ["concatenate", "flowfile", "content", "text"]

    CONCATENATE_COUNT = PropertyDescriptor(
        name="Concatenate Count",
        description="Number of FlowFiles to concatenate before emitting a new FlowFile.",
        required=True,
        validators=[StandardValidators.POSITIVE_INTEGER_VALIDATOR],
        expression_language_scope=ExpressionLanguageScope.NONE  # Sin evaluación de expresiones
    )

    property_descriptors = [CONCATENATE_COUNT]

    def __init__(self, **kwargs):
        super().__init__()
        self.concatenated_content = "" # Buffer para concatenar el contenido
        self.count = 0    # Contador de FlowFiles procesados (solo datos primitivos)

    def getPropertyDescriptors(self):
        return self.property_descriptors

    def transform(self, context, flowfile):

        # Obtener el número de FlowFiles a concatenar
        concatenate_count = int(context.getProperty(self.CONCATENATE_COUNT).getValue())
        
        # Leer el contenido del FlowFile como bytes
        content_bytes = flowfile.getContentsAsBytes()
        
        # Decodificar el contenido a texto (usando UTF-8)
        try:
            content = content_bytes.decode('utf-8')
        except UnicodeDecodeError:
            raise ValueError("FlowFile content is not valid UTF-8 text")
        if self.count != 0:
            self.concatenated_content = self.concatenated_content + "," + content
        else:
            self.concatenated_content = content
            
        self.count += 1
        
        if self.count >= concatenate_count:
            
            content = "[" + self.concatenated_content + "]"
            self.concatenated_content = ""
            self.count = 0
            return FlowFileTransformResult(relationship='success', contents=content, attributes={'flowfile': content})
        
        # Si no se ha alcanzado el número de FlowFiles, transferir el original
        return FlowFileTransformResult(relationship='original')